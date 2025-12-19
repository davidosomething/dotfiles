---@type vim.lsp.Config
return {
  on_init = function(client)
    if client.workspace_folders then
      local path = client.workspace_folders[1].name
      if path:sub(-5) == "/nvim" then
        local original = vim.tbl_get(client.config, "settings", "Lua") or {}
        client.config.settings = vim.tbl_deep_extend("force", original, {
          Lua = {
            runtime = { version = "LuaJIT" },
            -- Make the server aware of Neovim runtime files
            workspace = {
              library = {
                vim.env.VIMRUNTIME,
                "${3rd}/luv/library",
                -- @TODO using this because of https://github.com/neovim/nvim-lspconfig/issues/3189
                unpack(require("dko.utils.runtime").get_runtime_files()),
              },
            },
          },
        })
      end
    end
  end,
}
