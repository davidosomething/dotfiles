--- https://github.com/neovim/nvim-lspconfig/blob/master/lsp/oxfmt.lua

---@type vim.lsp.Config
return {
  --- Upstream also claims json/yaml/toml/html/css/markdown/vue/svelte, which
  --- either have their own pipeline in dko.utils.format or none at all --
  --- keep oxfmt on jsts until those pipelines want it
  filetypes = require("dko.utils.jsts").fts,

  --- oxfmt formats the whole buffer by itself, so name it as THE formatter
  --- instead of letting the winbar list every attached client,
  --- see dko.heirline.formatters -- cleared again in dko.behaviors.lsp
  --- NOTE guard by filetype if filetypes is ever widened, the markdown
  --- pipeline in dko.utils.format feeds vim.b.formatter to efm.format_with
  on_attach = function(_, bufnr)
    vim.b[bufnr].formatter = "oxfmt"
  end,

  --- Upstream's root_dir calls on_dir(nil) on a miss instead of not calling
  --- it, so without this oxfmt starts in single file mode in every project
  --- (and errors out when oxfmt is not installed at all). cf. lsp/eslint.lua
  workspace_required = true,
}
