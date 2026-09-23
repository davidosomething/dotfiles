--- https://github.com/neovim/nvim-lspconfig/blob/master/lsp/oxlint.lua

---@type vim.lsp.Config
return {
  --- Upstream's root_dir calls on_dir(nil) on a miss instead of not calling
  --- it, so without this oxlint starts in single file mode in every project.
  --- cf. after/lsp/oxfmt.lua
  workspace_required = true,
}
