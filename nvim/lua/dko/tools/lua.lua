local tools = require("dko.tools")

tools.register({
  mason_type = "tool",
  require = "_",
  name = "selene",
  fts = { "lua" },
  efm = function()
    ---@type EfmLinter
    return vim.tbl_extend(
      "force",
      require("efmls-configs.linters.selene"),
      { lintSource = "efmls" }
    )
  end,
})

tools.register({
  mason_type = "tool",
  require = "_",
  name = "stylua",
  fts = { "lua" },
  efm = function()
    ---@type EfmFormatter
    return vim.tbl_extend("force", require("efmls-configs.formatters.stylua"), {
      rootMarkers = { "stylua.toml", ".stylua.toml", ".editorconfig" },
    })
  end,
})

tools.register({
  mason_type = "lsp",
  require = "_",
  name = "lua_ls",
  runner = "mason-lspconfig",
  lspconfig = function()
    ---@type lspconfig.Config
    return {
      -- no more neodev https://github.com/neovim/neovim/pull/24592
      -- but uv and vim.cmd still not defined
      -- https://github.com/folke/neodev.nvim/issues/175
      on_init = function(client)
        local path = client.workspace_folders[1].name
        if
          not vim.uv.fs_stat(path .. "/.luarc.json")
          and not vim.uv.fs_stat(path .. "/.luarc.jsonc")
        then
          client.config.settings =
            vim.tbl_deep_extend("force", client.config.settings, {
              Lua = {
                runtime = {
                  -- Tell the language server which version of Lua you're using
                  -- (most likely LuaJIT in the case of Neovim)
                  version = "LuaJIT",
                },
                -- Make the server aware of Neovim runtime files
                workspace = {
                  checkThirdParty = false,
                  library = {
                    vim.env.VIMRUNTIME,
                    -- "${3rd}/luv/library"
                    -- "${3rd}/busted/library",
                  },
                  -- or pull in all of 'runtimepath'. NOTE: this is a lot slower
                  --library = vim.api.nvim_get_runtime_file("", true),
                },
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
