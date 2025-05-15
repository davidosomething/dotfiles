local dkotable = require("dko.utils.table")

-- Code formatting pipelines

local Methods = vim.lsp.protocol.Methods

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
M.pipelines["javascript"] = { require("dko.utils.format.javascript") }
M.pipelines["javascriptreact"] = M.pipelines["javascript"]
M.pipelines["typescript"] = M.pipelines["javascript"]
M.pipelines["typescriptreact"] = M.pipelines["javascript"]
M.pipelines["json"] = {
  function()
    require("dko.utils.format.efm").format_with(
      "prettier",
      { pipeline = "json" }
    )
  end,
  "efm:prettier",
}
M.pipelines["jsonc"] = M.pipelines["json"]
M.pipelines["lua"] = {
  function()
    require("dko.utils.format.efm").format_with("stylua", { pipeline = "lua" })
  end,
  "efm:stylua",
}
M.pipelines["markdown"] = { require("dko.utils.format.markdown") }
M.pipelines["yaml"] = {
  function()
    if vim.bo.filetype == "yaml.docker-compose" then
      vim.lsp.buf.format({ name = "docker_compose_language_service" })
      notify({ "docker_compose_language_service" })
      return
    end
    require("dko.utils.format.efm").format_with(
      "yamlfmt",
      { pipeline = "yamlfmt" }
    )
  end,
}

--- See options for vim.lsp.buf.format
M.run_pipeline = function(options)
  local pipelinedef = M.pipelines[vim.bo.filetype]
  if pipelinedef then
    return pipelinedef[1]()
  end

  local names = {}
  options = vim.tbl_deep_extend("force", options or {}, {
    ---@param client vim.lsp.Client
    filter = function(client)
      if not client:supports_method(Methods.textDocument_formatting) then
        return false
      end

      if client.name == "efm" then
        local configs =
          require("dko.tools").get_efm_languages()[vim.bo.filetype]
        local filtered = vim.tbl_filter(function(config)
          if config.formatCommand ~= nil then
            table.insert(
              names,
              ("efm[%s]"):format(
                vim.fn.fnamemodify(config.formatCommand:match("([^%s]+)"), ":t")
              )
            )
            return true
          end
          return false
        end, configs or {})
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
  vim.b[bufnr].formatters = dkotable.append(copy, name)

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
