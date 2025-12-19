for ft, parser in pairs({
  dotenv = "bash",
  javascriptreact = "jsx",
  tiltfile = "starlark",
  typescriptreact = "tsx",
}) do
  vim.treesitter.language.register(parser, ft)
end
