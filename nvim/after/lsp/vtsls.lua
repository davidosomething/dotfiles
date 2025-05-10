local dkots = require("dko.utils.typescript")
return {
  on_attach = dkots.ts_ls.config.on_attach,
  handlers = dkots.ts_ls.config.handlers,

  -- importModuleSpecifier https://github.com/LazyVim/LazyVim/discussions/3623#discussioncomment-10089949
  settings = {
    javascript = {
      preferences = {
        importModuleSpecifier = "non-relative", -- "project-relative",
      },
    },
    typescript = {
      preferences = {
        importModuleSpecifier = "non-relative", -- "project-relative",
      },
    },
  },
}
