local dkotools = require("dko.tools")

dkotools.register({
  name = "efm",
  runner = "lspconfig",
})

vim.lsp.config["version-lsp"] = {
  cmd = { "version-lsp" },
  filetypes = { "json", "toml", "gomod", "yaml" },
  on_attach = function(client, bufnr)
    local diagnostic_ns = vim.lsp.diagnostic.get_namespace(client.id)
    --- Use virtual text for version-lsp diagnostics
    vim.diagnostic.config({
      float = false,
      underline = false,
      virtual_text = true,
    }, diagnostic_ns)
  end,
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
