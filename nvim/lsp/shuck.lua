--- @type vim.lsp.Config
return {
  cmd = { "shuck", "server" },
  filetypes = { "sh", "bash", "zsh", "ksh" },
  root_markers = { ".shuck.toml", "shuck.toml", ".git" },
}
