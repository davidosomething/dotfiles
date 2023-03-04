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
  "composer.json",
  "Gemfile",
  "package.json",
  "requirements.txt",
  "tsconfig.json",
}

---Look upwards dirs for a file match
---@param patterns table
---@return string|nil root
M.get_root_by_patterns = function(patterns)
  if not patterns or #patterns == 0 then
    return nil
  end

  -- @TODO port over old dko#project#GetRootByFileMakrer
  -- if null-ls ever screws this up
  -- or if i change up lazy loading
  -- otherwise let's not re-invent the wheel

  -- Must call this to init cache table first
  local ok, cache = pcall(require, "null-ls.helpers.cache")
  if not ok then
    return nil
  end

  local u = require("null-ls.utils")

  local getter = cache.by_bufnr(function(params)
    return u.root_pattern(unpack(patterns))(params.bufname)
  end)

  return getter({ bufname = vim.api.nvim_buf_get_name(0) })
end

return M
