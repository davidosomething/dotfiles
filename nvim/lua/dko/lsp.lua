local M = {}

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

local format_timeout = 500

M.has_prettier = function()
  local null_ls_sources =
    require("null-ls.sources").get_available(vim.bo.filetype)
  for _, source in pairs(null_ls_sources) do
    if source.name == "prettier" then
      return true
    end
  end
  return false
end

M.format_with_null_ls = function()
  vim.lsp.buf.format({ async = false, name = "null-ls" })
end

-- returns instance of vim.lsp.client, see doc in lua/vim/lsp.lua
M.get_eslint = function()
  return require("lspconfig.util").get_active_client_by_name(0, "eslint")
end

M.format_with_eslint = function(eslint)
  eslint = eslint or M.get_eslint()
  -- https://github.com/neovim/nvim-lspconfig/blob/master/lua/lspconfig/server_configurations/eslint.lua#L152-L159
  vim.notify("eslint.applyAllFixes", vim.log.levels.INFO, notify_opts)
  eslint.request_sync(
    "workspace/executeCommand", -- method
    { -- params
      command = "eslint.applyAllFixes",
      arguments = {
        {
          uri = vim.uri_from_bufnr(0),
          version = vim.lsp.util.buf_versions[0],
        },
      },
    },
    format_timeout, -- timeout
    0 -- bufnr
  )
end

M.format_jsts = function()
  local queue = {}

  -- @TODO skip this if eslint-prettier-plugin is found?
  if M.has_prettier() then
    table.insert(queue, M.format_with_null_ls)
  end

  local eslint = M.get_eslint()
  if eslint then
    table.insert(queue, function() M.format_with_eslint(eslint) end)
  end

  for i, formatter in ipairs(queue) do
    -- defer with increasing time to ensure eslint runs after prettier
    ---@diagnostic disable-next-line: param-type-mismatch
    vim.defer_fn(formatter, format_timeout * (i - 1))
  end
end

--- See options for vim.lsp.buf.format
M.format = function(options)
  if
    vim.tbl_contains(
      { "typescript", "typescriptreact", "javascript", "javascriptreact" },
      vim.bo.filetype
    )
  then
    return M.format_jsts()
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
    { "n", "i" },
    "<C-g>",
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
