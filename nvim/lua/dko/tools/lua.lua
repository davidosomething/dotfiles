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
      settings = {
        Lua = {
          format = { enable = false },
          hint = { enable = true },
          runtime = {
            -- Tell the language server which version of Lua you're using
            -- (most likely LuaJIT in the case of Neovim)
            version = "LuaJIT",
          },
          workspace = {
            maxPreload = 1000,
            preloadFileSize = 500,
            checkThirdParty = false,
            library = {
              vim.env.VIMRUNTIME,
              "${3rd}/luv/library",
              -- "${3rd}/busted/library",
              -- pull in all of 'runtimepath'. NOTE: this is a lot slower
              unpack(vim.api.nvim_get_runtime_file("", true)),
            },
          },
        },
      },
    }
  end,
})
