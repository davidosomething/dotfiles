--- @type vim.lsp.Config
return {
  cmd = { "mise", "lsp" },
  filetypes = { "toml" },
  -- NOTE: order matters; vim.fs.root() returns the first marker (in list
  -- order) that matches anywhere upward, so new-style markers must come
  -- before legacy ones (e.g. ~/mise.local.toml would match at ~ and win).
  root_markers = {
    "mise/config.toml",
    ".mise", -- directory marker; covers .mise/config.toml and .mise/conf.d/**
    "mise.toml", -- legacy
    ".mise.toml", -- legacy
    "mise.local.toml", -- legacy
  },
}
