local tools = require("dko.tools")

tools.register({
  mason_type = "tool",
  require = "_",
  name = "selene",
  fts = { "lua" },
  efm = function()
    return {
      lintCommand = "selene --display-style quiet -",
      lintIgnoreExitCode = true,
      lintSource = "efm",
      lintStdin = true,
      prefix = "selene",
      requireMarker = true,
      rootMarkers = { "selene.toml" },
    }
  end,
})

tools.register({
  mason_type = "tool",
  require = "_",
  name = "stylua",
  fts = { "lua" },
  efm = function()
    -- custom since efmls has bad override
    -- @see https://github.com/creativenull/efmls-configs-nvim/pull/54
    ---@type EfmFormatter
    return {
      formatCanRange = true,
      formatCommand = "stylua --color Never ${--range-start:charStart} ${--range-end:charEnd} -",
      formatStdin = true,
      rootMarkers = { "stylua.toml", ".stylua.toml", ".editorconfig" },
    }
  end,
})

tools.register({
  mason_type = "lsp",
  require = "_",
  name = "lua_ls",
  runner = "mason-lspconfig",
  ---@return LspconfigDef
  lspconfig = function()
    return {
      -- no more neodev https://github.com/neovim/neovim/pull/24592
      on_init = function(client)
        local path = client.workspace_folders[1].name
        if
          not vim.uv.fs_stat(path .. "/.luarc.json")
          and not vim.uv.fs_stat(path .. "/.luarc.jsonc")
        then
          client.config.settings =
            vim.tbl_deep_extend("force", client.config.settings.Lua, {
              runtime = {
                -- Tell the language server which version of Lua you're using (most likely LuaJIT in the case of Neovim)
                version = "LuaJIT",
              },
              -- Make the server aware of Neovim runtime files
              workspace = {
                library = { vim.env.VIMRUNTIME },
                -- or pull in all of 'runtimepath'. NOTE: this is a lot slower
                --library = vim.api.nvim_get_runtime_file("", true),
              },
            })
          client.notify(
            vim.lsp.protocol.Methods.workspace_didChangeConfiguration,
            { settings = client.config.settings }
          )
        end
        return true
      end,

      settings = {
        Lua = {
          format = { enable = false },
          hint = { enable = true },
          workspace = {
            maxPreload = 1000,
            preloadFileSize = 500,
            checkThirdParty = false,
          },
        },
      },
    }
  end,
})
