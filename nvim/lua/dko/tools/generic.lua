local dkotools = require("dko.tools")

dkotools.register({
  name = "efm",
  runner = "lspconfig",
})

vim.lsp.config["version-lsp"] = {
  cmd = { "version-lsp" },
  filetypes = { "json", "toml", "gomod", "yaml" },
  root_markers = {
    "package.json",
    "pnpm-workspace.yaml",
    "Cargo.toml",
    "go.mod",
    ".git",
  },
  settings = {
    ["version-lsp"] = {
      cache = {
        refreshInterval = 86400000, -- 24 hours (milliseconds)
      },
      registries = {
        npm = { enabled = true },
        crates = { enabled = true },
        goProxy = { enabled = true },
        github = { enabled = true },
        pnpmCatalog = { enabled = true },
      },
    },
  },
}
dkotools.register({
  name = "version-lsp",
  runner = "lspconfig",
})
