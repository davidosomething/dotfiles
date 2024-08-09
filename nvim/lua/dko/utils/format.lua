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
pipelines["javascript"] = function()
  require("dko.utils.format.javascript")(notify)
end
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

  vim.b.enable_format_on_save = true

  -- Track formatters, non-exclusively, non-LSPs might add to this table
  -- or fire the autocmd
  local name = clients[1].name

  -- NOTE: You cannot table.insert(vim.b.formatters, name) -- need to have a
  -- temp var and assign full table at once because the vim.b vars are special
  local formatters = vim.b.formatters
  if formatters == nil then
    formatters = { name }
  else
    table.insert(formatters, name)
  end
  vim.b.formatters = formatters

  vim.cmd.doautocmd("User", "FormatterAdded")
end

-- LspDetach autocmd callback
M.disable_on_lspdetach = function(args)
  -- was already disabled manually?
  if not vim.b.enable_format_on_save then
    return
  end

  local bufnr = args.buf
  local detached_client_id = args.data.client_id

  -- @TODO could i just check using { bufnr, and method } here? Or does it still
  -- include in the client being detached?
  local capable_clients = vim.lsp.get_clients({
    bufnr = bufnr,
    method = Methods.textDocument_formatting,
  })
  local still_has_formatter = vim.iter(capable_clients):any(function(client)
    return client.id ~= detached_client_id
  end)
  if still_has_formatter then
    return
  end

  vim.b.enable_format_on_save = false
  vim.schedule(function()
    vim.notify(
      "Format on save disabled, no capable clients attached",
      vim.log.levels.INFO,
      { title = "[LSP]", render = "compact" }
    )
  end)
end

-- autocmd callback for *WritePre
M.format_on_save = function()
  -- callback gets arg
  -- {
  --   buf = 1,
  --   event = "BufWritePre",
  --   file = "nvim/lua/dko/behaviors.lua",
  --   id = 127,
  --   match = "/home/davidosomething/.dotfiles/nvim/lua/dko/behaviors.lua"
  -- }
  if not vim.b.enable_format_on_save then
    return
  end
  M.run_pipeline({ async = false })
end

return M
