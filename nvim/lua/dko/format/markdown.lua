return function()
  if vim.b.has_markdownlint == nil then
    vim.b.has_markdownlint = #vim.fs.find({
      ".markdownlint.json",
      ".markdownlint.jsonc",
      ".markdownlint.yaml",
    }, { limit = 1, upward = true, type = "file" })
  end
  require("dko.format.efm").format_with(
    vim.b.has_markdownlint == true and "markdownlint" or "prettier",
    { pipeline = "markdown" }
  )
end
