local M = {}

-- https://github.com/jose-elias-alvarez/null-ls.nvim/blob/main/lua/null-ls/builtins/formatting/eslint.lua#L48-L58
M.ESLINT_ROOTS = {
  -- https://eslint.org/docs/latest/user-guide/configuring/configuration-files-new
  "eslint.config.js",
  -- https://eslint.org/docs/user-guide/configuring/configuration-files#configuration-file-formats
  ".eslintrc",
  ".eslintrc.js",
  ".eslintrc.cjs",
  ".eslintrc.yaml",
  ".eslintrc.yml",
  ".eslintrc.json",
  "package.json",
}

M.PROJECT_ROOTS = {
  ".luarc.json",
  "composer.json",
  "Gemfile",
  "justfile",
  "Makefile",
  "package.json",
  "pubspec.yaml", -- flutter / dart
  "requirements.txt",
  "tsconfig.json",
}

---Look upwards dirs for a file match
---@param patterns? table
---@return string|nil root
M.get_root_by_patterns = function(patterns)
  patterns = patterns or M.PROJECT_ROOTS

  -- Must call this to init cache table first
  local ok, cache = pcall(require, "null-ls.helpers.cache")
  if not ok then
    vim.notify("Could not load null-ls cache", vim.log.levels.ERROR, {
      title = "dko/project/get_root_by_patterns",
    })
    return nil
  end

  local getter = cache.by_bufnr(function(params)
    return require("null-ls.utils").root_pattern(unpack(patterns))(params.start)
  end)

  local bufname = vim.api.nvim_buf_get_name(0)
  local start = bufname:len() > 0 and bufname or vim.uv.cwd()
  return getter({ start = start, bufnr = 0 })
end

---@param opts? table vim.fs.find opts
---@return string|nil -- git root
M.get_git_root = function(opts)
  -- gitsigns did the work for us!
  if not opts then
    local from_gitsigns =
      require("dko.utils.object").get(vim.b, "gitsigns_status_dict.root")
    if from_gitsigns then
      return from_gitsigns
    end
  end

  local find_opts = vim.tbl_extend("force", {
    limit = 1,
    upward = true,
    type = "directory",
  }, opts or {})
  local res = vim.fs.find(".git", find_opts)
  return res[1]
end

--- Impure function that sets up root if needed
---@return string -- git root
M.root = function()
  if not vim.b.dko_project_root then
    vim.b.dko_project_root = M.get_root_by_patterns(M.PROJECT_ROOTS)
    vim.b.dko_project_root = vim.b.dko_project_root or M.get_git_root()
  end
  return vim.b.dko_project_root
end

-- ===========================================================================

return M
