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
---@type table<ft, function>
local pipelines = {}
pipelines["html"] = function()
  require("dko.utils.format.efm").format({ pipeline = "html" })
end
pipelines["javascript"] = require("dko.utils.format.javascript")
pipelines["javascriptreact"] = pipelines["javascript"]
pipelines["typescript"] = pipelines["javascript"]
pipelines["typescriptreact"] = pipelines["javascript"]
pipelines["json"] = function()
  require("dko.utils.format.efm").format_with("prettier", { pipeline = "json" })
end
pipelines["jsonc"] = pipelines["json"]
pipelines["lua"] = function()
  require("dko.utils.format.efm").format_with("stylua", { pipeline = "lua" })
end
pipelines["markdown"] = require("dko.utils.format.markdown")
pipelines["yaml"] = function()
  if vim.bo.filetype == "yaml.docker-compose" then
    vim.lsp.buf.format({ name = "docker_compose_language_service" })
    notify({ "docker_compose_language_service" })
    return
  end
  require("dko.utils.format.efm").format_with(
    "yamlfmt",
    { pipeline = "yamlfmt" }
  )
end

--- See options for vim.lsp.buf.format
M.run_pipeline = function(options)
  local pipeline = pipelines[vim.bo.filetype]
  if pipeline then
    return pipeline()
  end

  local names = {}
  options = vim.tbl_deep_extend("force", options or {}, {
    filter = function(client)
      if not client.supports_method(Methods.textDocument_formatting) then
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
        end, configs)
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

-- Add formatter to vim.b.formatters and fire autocmd (e.g. update heirline)
M.add_formatter = function(name)
  if vim.b.formatters ~= nil and vim.tbl_contains(vim.b.formatters, name) then
    return
  end

  -- NOTE: You cannot table.insert(vim.b.formatters, name) -- need to have a
  -- temp var and assign full table at once because the vim.b vars are special
  local copy = vim.tbl_extend("force", {}, vim.b.formatters or {})
  vim.b.formatters = dkotable.append(copy, name)
  vim.cmd.doautocmd("User", "FormattersChanged")
end

M.remove_formatter = function(name)
  if vim.b.formatters == nil then
    return
  end
  for i, needle in pairs(vim.b.formatters) do
    if needle == name then
      local copy = vim.tbl_extend("force", {}, vim.b.formatters or {})
      table.remove(copy, i)
      vim.b.formatters = copy
      vim.cmd.doautocmd("User", "FormattersChanged")
      return
    end
  end
end

-- =============================================================================
-- Autocmd handlers
-- =============================================================================

-- LspAttach autocmd callback
M.enable_on_lspattach = function(args)
  local bufnr = args.buf
  local clients = vim.lsp.get_clients({
    id = args.data.client_id,
    bufnr = bufnr,
    method = Methods.textDocument_formatting,
  })
  if #clients == 0 then -- just to shut up type checking
    return
  end

  -- Track formatters, non-exclusively, non-LSPs might add to this table
  -- or fire the autocmd
  local name = clients[1].name
  M.add_formatter(name)
  vim.b.enable_format_on_save = true
end

-- LspDetach autocmd callback
M.disable_on_lspdetach = function(args)
  -- was already disabled manually?
  if not vim.b.enable_format_on_save then
    return
  end

  local bufnr = args.buf
  local detached_client_id = args.data.client_id

  -- Unregister the client from formatters (and update heirline)
  local detached_client = vim.lsp.get_client_by_id(detached_client_id)
  if detached_client ~= nil then
    local name = detached_client.name
    M.remove_formatter(name)
  end

  vim.b.enable_format_on_save = vim.b.formatters == nil or #vim.b.formatters > 0
  if vim.b.enable_format_on_save then
    vim.schedule(function()
      vim.notify(
        "Format on save disabled, no capable clients attached",
        vim.log.levels.INFO,
        { title = "[LSP]", render = "wrapped-compact" }
      )
    end)
  end
end

return M
