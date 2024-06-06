-- Code formatting pipelines

local Methods = vim.lsp.protocol.Methods

---@param names string[]
local function notify(names)
  if #names == 0 then
    return
  end
  vim.notify("format", vim.log.levels.INFO, {
    render = "compact",
    title = ("[LSP] %s"):format(table.concat(names, ", ")),
  })
end

local M = {}

-- ===========================================================================

---@TODO move this to individual ftplugins ?
---@type table<ft, function>
local pipelines = {}
pipelines["html"] = function()
  require("dko.format.efm").format({ pipeline = "html" })
end
pipelines["javascript"] = function()
  require("dko.format.javascript")(notify)
end
pipelines["javascriptreact"] = pipelines["javascript"]
pipelines["typescript"] = pipelines["javascript"]
pipelines["typescriptreact"] = pipelines["javascript"]
pipelines["json"] = function()
  require("dko.format.efm").format_with("prettier", { pipeline = "json" })
end
pipelines["jsonc"] = pipelines["json"]
pipelines["lua"] = function()
  require("dko.format.efm").format_with("stylua", { pipeline = "lua" })
end
pipelines["markdown"] = require("dko.format.markdown")
pipelines["yaml"] = function()
  if vim.bo.filetype == "yaml.docker-compose" then
    vim.lsp.buf.format({ name = "docker_compose_language_service" })
    notify({ "docker_compose_language_service" })
    return
  end
  require("dko.format.efm").format_with("yamlfmt", { pipeline = "yamlfmt" })
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

M.enable_on_lspattach = function(args)
  --[[
    {
      buf = 1,
      data = {
        client_id = 1
      },
      event = "LspAttach",
      file = "/home/davidosomething/.dotfiles/nvim/lua/dko/behaviors.lua",
      group = 11,
      id = 13,
      match = "/home/davidosomething/.dotfiles/nvim/lua/dko/behaviors.lua"
    }
    ]]
  local bufnr = args.buf
  local client = vim.lsp.get_client_by_id(args.data.client_id)
  if not client then -- just to shut up type checking
    return
  end

  -- Maybe enable format on save if currently unset
  -- (you can set false manually)
  if
    vim.b.enable_format_on_save == nil
    and client.supports_method(
      Methods.textDocument_formatting,
      { bufnr = bufnr }
    )
  then
    vim.b.enable_format_on_save = true
  end
end

-- autocmd callback
M.disable_on_lspdetach = function(args)
  -- was already disabled manually?
  if not vim.b.enable_format_on_save then
    return
  end

  local bufnr = args.buf
  local detached_client_id = args.data.client_id

  -- @TODO could i just check using { bufnr, and method } here? Or does it still
  -- include in the client being detached?
  local clients = vim.lsp.get_clients({ bufnr = bufnr })
  local still_has_formatter = vim.iter(clients):any(function(client)
    return client.id ~= detached_client_id
      and client.supports_method(
        Methods.textDocument_formatting,
        { bufnr = bufnr }
      )
  end)
  vim.b.enable_format_on_save = still_has_formatter
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
