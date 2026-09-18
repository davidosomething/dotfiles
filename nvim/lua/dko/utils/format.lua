-- Code formatting pipelines

---@param names string[]
local function notify(names)
  if #names == 0 then
    return
  end
  vim.notify("format", vim.log.levels.INFO, {
    render = "wrapped-compact",
    title = ("[LSP] %s"):format(table.concat(names, ", ")),
  })
end

local M = {}

-- ===========================================================================

---@TODO move this to individual ftplugins?
---@type table<ft, { [1]: function, [2]: string }>
M.pipelines = {}
M.pipelines["html"] = {
  function()
    require("dko.utils.format.efm").format_with(
      "prettier",
      { pipeline = "html" }
    )
  end,
  "efm:prettier",
}

M.pipelines["javascript"] = { require("dko.utils.format.javascript").format }

M.pipelines["javascriptreact"] = M.pipelines["javascript"]
M.pipelines["typescript"] = M.pipelines["javascript"]
M.pipelines["typescriptreact"] = M.pipelines["javascript"]
M.pipelines["json"] = {
  require("dko.utils.format.json").format,
}
M.pipelines["jsonc"] = M.pipelines["json"]
M.pipelines["lua"] = {
  function()
    require("dko.utils.format.efm").format_with("stylua", { pipeline = "lua" })
  end,
  "efm:stylua",
}
M.pipelines["markdown"] = {
  function()
    -- setup in ftplugin/markdown.lua
    require("dko.utils.format.efm").format_with(
      vim.b.formatter,
      { pipeline = "markdown" }
    )
  end,
}
M.pipelines["yaml"] = {
  function()
    require("dko.utils.format.efm").format_with(
      "yamlfmt",
      { pipeline = "yamlfmt" }
    )
  end,
}
M.pipelines["yaml.docker-compose"] = M.pipelines["yaml"]

---Timeout for synchronous LSP format requests, more patient over ssh
---@return number
M.timeout_ms = function()
  return vim.env.SSH_CLIENT and 3000 or 1000
end

-- ===========================================================================
-- Waiting out LSP startup
-- ===========================================================================

--- How long to block for a first client to attach to the buffer
local ATTACH_WAIT_MS = 1000
--- How long to block for attached clients to finish initializing
local INIT_WAIT_MS = 5000

---@return vim.lsp.Client[] -- attached to the buffer, initialized or not
local function all_clients()
  return vim.lsp.get_clients({ bufnr = 0, _uninitialized = true })
end

---@return vim.lsp.Client[] -- attached to the buffer, still initializing
local function starting_clients()
  return vim.tbl_filter(function(client)
    return not client.initialized
  end, all_clients())
end

---@return boolean -- some enabled LSP config claims this buffer's filetype
local function expects_clients()
  return vim.iter(require("dko.tools").standalone_lsp_names):any(function(name)
    local config = vim.lsp.config[name]
    return config ~= nil
      and config.filetypes ~= nil
      and vim.list_contains(config.filetypes, vim.bo.filetype)
  end)
end

---Block until the buffer's LSP clients have attached and initialized, so a
---pipeline doesn't format with a fallback -- or silently format nothing --
---while the formatter it wants is still starting. Interruptible with CTRL-C.
---@return boolean -- false if the wait was interrupted
M.wait_for_clients = function()
  --- A config whose root_dir never resolves looks exactly like one that is
  --- still deciding, so only wait for a first attach when nothing at all is
  --- attached yet and something was expected to be
  local wait_for_attach = #all_clients() == 0 and expects_clients()
  if not wait_for_attach and #starting_clients() == 0 then
    return true
  end

  --- fidget cannot render while vim.wait has the loop, so echo it and turn
  --- the winbar orange (see dko.heirline.winbar), then flush both before
  --- blocking -- nothing repaints until the wait is over
  vim.b.dko_format_waiting = true
  vim.api.nvim_echo(
    { { "[LSP] waiting for clients to start...", "Comment" } },
    false,
    {}
  )
  vim.cmd.redrawstatus()
  vim.cmd.redraw()

  local interrupted = false
  if wait_for_attach then
    local _, reason = vim.wait(ATTACH_WAIT_MS, function()
      return #all_clients() > 0
    end, 25)
    --- Timing out here just means nothing attached, which the pipeline
    --- already reports in its own words
    interrupted = reason == -2
  end

  local starting = {}
  if not interrupted then
    local _, reason = vim.wait(INIT_WAIT_MS, function()
      starting = starting_clients()
      return #starting == 0
    end, 25)
    interrupted = reason == -2
    if reason == -1 then
      require("dko.utils.notify").toast(
        ("Formatting without %s, still starting"):format(
          table.concat(
            vim.tbl_map(function(client)
              return client.name
            end, starting),
            ", "
          )
        ),
        vim.log.levels.WARN,
        { group = "format", render = "wrapped-compact", title = "[LSP] format" }
      )
    end
  end

  vim.b.dko_format_waiting = nil
  vim.api.nvim_echo({}, false, {})
  vim.cmd.redrawstatus()
  return not interrupted
end

--- See options for vim.lsp.buf.format
M.run_pipeline = function(options)
  if not M.wait_for_clients() then
    return
  end

  local pipelinedef = M.pipelines[vim.bo.filetype]
  if pipelinedef then
    return pipelinedef[1]()
  end

  local names = {}
  options = vim.tbl_deep_extend("force", options or {}, {
    ---@param client vim.lsp.Client
    filter = function(client)
      if not client:supports_method("textDocument/formatting") then
        return false
      end

      if client.name == "efm" then
        local tool_configs = require("dko.tools").config_with_efm_by_ft[vim.bo.filetype]
        local filtered = vim.tbl_filter(function(tool)
          local efm = tool.efm()
          if efm.formatCommand ~= nil then
            table.insert(
              names,
              ("efm[%s]"):format(
                vim.fn.fnamemodify(efm.formatCommand:match("([^%s]+)"), ":t")
              )
            )
            return true
          end
          return false
        end, tool_configs or {})
        return #filtered ~= 0
      end

      table.insert(names, client.name)
      return true
    end,
  })

  -- https://github.com/neovim/neovim/blob/master/runtime/lua/vim/lsp/buf.lua#L156-L196
  vim.lsp.buf.format(options)
  notify(names)
end

---@class AddFormatterOptions
---@field autoenable? boolean -- default true, autoenable when first formatter added
---@field heirline? string -- name to show in heirline winbar

---Add formatter to vim.b.formatters and fire autocmd (e.g. update heirline)
---@param bufnr number
---@param name string like "lua_ls" or "efm"
---@param opts? AddFormatterOptions
M.add_formatter = function(bufnr, name, opts)
  opts = vim.tbl_extend("force", {
    autoenable = true,
  }, opts)

  -- Already added
  if
    vim.b[bufnr].formatters ~= nil
    and vim.list_contains(vim.b[bufnr].formatters, name)
  then
    return
  end

  -- NOTE: You cannot table.insert(vim.b.formatters, name).
  -- Need to have a temp var and assign full table. vim.b vars are special
  local copy = vim.tbl_extend("force", {}, vim.b[bufnr].formatters or {})
  vim.b[bufnr].formatters = require("dko.utils.table").append(copy, name)

  -- Auto-enable format on save if it was not explicitly disabled (false)
  vim.b.enable_format_on_save = opts.autoenable
    and vim.b.enable_format_on_save ~= false

  vim.cmd.doautocmd("User", "FormattersChanged") -- Should trigger ui redraw
end

---Remove formatter from vim.b.formatters and fire autocmd (e.g. update heirline)
---@param bufnr number
---@param name string like "lua_ls" or "efm"
M.remove_formatter = function(bufnr, name)
  if vim.b[bufnr].formatters == nil then
    return
  end
  for i, needle in ipairs(vim.b[bufnr].formatters) do
    if needle == name then
      -- NOTE: You cannot table.remove(vim.b.formatters, i).
      -- Need to have a temp var and assign full table. vim.b vars are special
      local copy = vim.tbl_extend("force", {}, vim.b[bufnr].formatters or {})
      table.remove(copy, i)
      vim.b[bufnr].formatters = copy
      vim.cmd.doautocmd("User", "FormattersChanged") -- Should trigger ui redraw
      return
    end
  end
end

return M
