return {
  settings = {
    basedpyright = {
      disableOrganizeImports = true, -- prefer ruff or isort
      typeCheckingMode = "standard",
    },
    python = {
      analysis = {
        -- Ignore all files for analysis to exclusively use Ruff for linting
        ignore = { "*" },
      },
    },
  },
}
