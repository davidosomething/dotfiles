-- Code formatting pipelines

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
      if
        not client.supports_method(
          vim.lsp.protocol.Methods.textDocument_formatting
        )
      then
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

return M
