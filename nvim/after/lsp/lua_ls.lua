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
          -- provides vim.*
          vim.env.VIMRUNTIME,

          -- provide plugin completions and types
          -- pull in all of 'runtimepath'. NOTE: this is a lot slower
          -- unpack(vim.api.nvim_get_runtime_file("", true)),
          -- @TODO using this because of https://github.com/neovim/nvim-lspconfig/issues/3189
          unpack(require("dko.utils.runtime").get_runtime_files()),

          "${3rd}/luv/library",
          -- "${3rd}/busted/library",
        },
      },
    },
  },
}
