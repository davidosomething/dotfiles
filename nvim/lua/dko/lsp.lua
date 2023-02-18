local M = {}

-- ===========================================================================
-- LSP progress for bars
-- ===========================================================================

---@class ProgressMessage
---@field name string client name e.g. lua_ls or null-ls
---@field title string usually what the client is doing
---@field message string sometimes filename, for null-ls it is the source name
---@field percentage number
---@field done boolean
---@field progress boolean

-- ripped directly from $VIMRUNTIME/lua/vim/lsp/util.lua and added filter
-- param
--- Process and return progress reports from lsp server
---@param filter (table|nil) A table with key-value pairs used to filter the
---              returned clients. The available keys are:
---               - id (number): Only return clients with the given id
---               - bufnr (number): Only return clients attached to this buffer
---               - name (string): Only return clients with the given name
function M.get_progress_messages(filter)
  local new_messages = {}
  local progress_remove = {}

  for _, client in ipairs(vim.lsp.get_active_clients(filter)) do
    local messages = client.messages
    local data = messages
    for token, ctx in pairs(data.progress) do
      local new_report = {
        name = data.name,
        title = ctx.title or "empty title",
        message = ctx.message,
        percentage = ctx.percentage,
        done = ctx.done,
        progress = true,
      }
      table.insert(new_messages, new_report)

      if ctx.done then
        table.insert(progress_remove, { client = client, token = token })
      end
    end
  end

  for _, item in ipairs(progress_remove) do
    item.client.messages.progress[item.token] = nil
  end

  return new_messages
end

--- Hook this into
--- LspAttach, LspDetach, User LspProgressUpdate, and User LspRequest
---@param filter (table|nil) A table with key-value pairs used to filter the
---              returned clients. The available keys are:
---               - id (number): Only return clients with the given id
---               - bufnr (number): Only return clients attached to this buffer
---               - name (string): Only return clients with the given name
M.status_progress = function(filter)
  ---@type ProgressMessage[]
  local messages = M.get_progress_messages(filter)
  if #messages == 0 then
    return nil
  end

  local lowest = { percentage = 100 }
  for _, data in pairs(messages) do
    (function()
      if
        data.done
        or not data.progress
        or not data.percentage
        or data.percentage == 100
      then
        return
      end
      if data.percentage < lowest.percentage then
        lowest = data
      end
    end)()
  end
  if lowest.percentage == 100 then
    return nil
  end

  if lowest.name == "null-ls" then
    lowest.name = "null-ls[" .. lowest.message .. "]"
  end

  local util = require("dko.utils.progress")
  local bar = util.character(util.VERTICAL, lowest.percentage)
  return { messages = messages, lowest = lowest, bar = bar }
end

-- ===========================================================================
-- LSP Notifications
-- ===========================================================================

local notify_opts = {
  title = "LSP",
  render = "compact",
}

M.null_ls_notify_on_format = function(params)
  local source = params:get_source()
  vim.notify(
    "null-ls[" .. source.name .. "] format",
    vim.log.levels.INFO,
    notify_opts
  )
end

--- See options for vim.lsp.buf.format
M.format = function(options)
  if
    vim.tbl_contains(
      { "typescript", "typescriptreact", "javascript", "javascriptreact" },
      vim.bo.filetype
    )
    and require("lspconfig.util").get_active_client_by_name(0, "eslint")
  then
    -- https://github.com/neovim/nvim-lspconfig/blob/master/lua/lspconfig/server_configurations/eslint.lua#L152-L159
    vim.cmd("EslintFixAll")
    return
  end

  options = vim.tbl_deep_extend("force", options or {}, {
    filter = function(client)
      if not client.supports_method("textDocument/formatting") then
        return false
      end

      -- =====================================================================
      -- Filetype specific choices
      -- @TODO move this somewhere better
      -- =====================================================================

      if vim.tbl_contains({ "lua_ls", "tsserver" }, client.name) then
        vim.notify(
          client.name .. " disabled in dko/lsp.lua",
          vim.log.levels.INFO,
          notify_opts
        )
        return false
      end

      -- =====================================================================
      -- My null-ls runtime_condition will notify
      -- =====================================================================

      if client.name ~= "null-ls" then
        vim.notify(client.name .. " format", vim.log.levels.INFO, notify_opts)
      end

      return true
    end,
  })

  -- https://github.com/neovim/neovim/blob/master/runtime/lua/vim/lsp/buf.lua#L147-L187
  vim.lsp.buf.format(options)
end

-- ===========================================================================
-- Buffer: LSP integration
-- Mix of https://github.com/neovim/nvim-lspconfig#suggested-configuration
-- and :h lsp
-- ===========================================================================

-- buffer local map
local function lsp_opts(opts)
  opts = vim.tbl_extend("force", {
    noremap = true,
    silent = true,
    buffer = true,
  }, opts)
end

local map = vim.keymap.set

local function with_telescope(method)
  local ok, telescope = pcall(require, "telescope.builtin")
  if ok then
    return telescope[method]()
  end
  return nil
end

M.bind_lsp_mappings = function()
  local handlers = {
    definition = function()
      return with_telescope("lsp_definitions") or vim.lsp.buf.definition
    end,
    references = function()
      return with_telescope("lsp_references") or vim.lsp.buf.references
    end,
    implementation = function()
      return with_telescope("lsp_implementations") or vim.lsp.buf.implementation
    end,
    type_definition = function()
      return with_telescope("lsp_type_definitions")
        or vim.lsp.buf.type_definition
    end,
  }

  map(
    "n",
    "gD",
    vim.lsp.buf.declaration,
    lsp_opts({ desc = "LSP declaration" })
  )
  map("n", "gd", handlers.definition, lsp_opts({ desc = "LSP definition" }))
  map("n", "K", vim.lsp.buf.hover, lsp_opts({ desc = "LSP hover" }))

  map(
    "n",
    "gi",
    handlers.implementation,
    lsp_opts({ desc = "LSP implementation" })
  )
  map(
    "n",
    "<C-k>",
    vim.lsp.buf.signature_help,
    lsp_opts({ desc = "LSP signature_help" })
  )
  --map('n', '<space>wa', vim.lsp.buf.add_workspace_folder, bufopts)
  --map('n', '<space>wr', vim.lsp.buf.remove_workspace_folder, bufopts)
  --[[ map('n', '<space>wl', function()
    print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
  end, bufopts) ]]
  map(
    "n",
    "<Leader>D",
    handlers.type_definition,
    lsp_opts({ desc = "LSP type_definition" })
  )
  map("n", "<Leader>rn", vim.lsp.buf.rename, lsp_opts({ desc = "LSP rename" }))
  map(
    "n",
    "<Leader>ca",
    vim.lsp.buf.code_action,
    lsp_opts({ desc = "LSP Code Action" })
  )

  map("n", "gr", handlers.references, lsp_opts({ desc = "LSP references" }))

  map("n", "<A-=>", function()
    require("dko.lsp").format({ async = false })
  end, lsp_opts({ desc = "Fix and format buffer with dko.lsp.format_buffer" }))
end

-- ===========================================================================

return M
