local nvim_dir = ("%s/nvim"):format(vim.env.XDG_CONFIG_HOME)
local after_dir = ("%s/after"):format(nvim_dir)

-- @TODO using this because of https://github.com/neovim/nvim-lspconfig/issues/3189
-- Need to call this after plugins loaded since they change runtime files
local function get_runtime_files()
  return vim
    .iter(vim.api.nvim_get_runtime_file("", true))
    :filter(function(v)
      return v ~= nvim_dir and v ~= after_dir
    end)
    :totable()
end

---@type vim.lsp.Config
return {
  on_init = function(client)
    if client.workspace_folders then
      local path = client.workspace_folders[1].name
      print(path)
      if path:sub(-5) == "/nvim" then
        local original = client.config.settings.Lua --[[@as table]]
        client.config.settings.Lua = vim.tbl_deep_extend("force", original, {
          runtime = {
            -- Tell the language server which version of Lua you're using (most
            -- likely LuaJIT in the case of Neovim)
            version = "LuaJIT",
            -- Tell the language server how to find Lua modules same way as Neovim
            -- (see `:h lua-module-load`)
            path = {
              "lua/?.lua",
              "lua/?/init.lua",
            },
          },
          -- Make the server aware of Neovim runtime files
          workspace = {
            checkThirdParty = false,
            library = {
              vim.env.VIMRUNTIME,
              -- Depending on the usage, you might want to add additional paths
              -- here.

              "${3rd}/luv/library",
              -- '${3rd}/busted/library'

              -- provide plugin completions and types
              -- pull in all of 'runtimepath'. NOTE: this is a lot slower
              -- unpack(vim.api.nvim_get_runtime_file("", true)),
              -- @TODO using this because of https://github.com/neovim/nvim-lspconfig/issues/3189
              unpack(get_runtime_files()),
            },
            -- Or pull in all of 'runtimepath'.
            -- NOTE: this is a lot slower and will cause issues when working on
            -- your own configuration.
            -- See https://github.com/neovim/nvim-lspconfig/issues/3189
            -- library = {
            --   vim.api.nvim_get_runtime_file('', true),
            -- }
          },
        })
      end
    end
  end,
  ---@type vim.lsp.Config
  settings = {
    Lua = {
      format = { enable = false },
    },
  },
}
