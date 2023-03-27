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
  "Makefile",
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

  local getter = cache.by_bufnr(function(params)
    return require("null-ls.utils").root_pattern(unpack(patterns))(params.start)
  end)

  local bufname = vim.api.nvim_buf_get_name(0)
  local start = bufname:len() > 0 and bufname or vim.loop.cwd()
  return getter({ start = start, bufnr = 0 })
end

---@param from string
---@return string|nil git root
M.git_root = function(from)
  from = from or vim.api.nvim_buf_get_name(0)
  local start = from:len() > 0 and from or vim.loop.cwd()
  if not start then
    return nil
  end
  local ok, utils = pcall(require, "null-ls.utils")
  return ok and utils.root_pattern(".git")(start) or nil
end

return M
