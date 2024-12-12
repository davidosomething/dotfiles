local M = {}

M.PROJECT_ROOTS = {
  ".luarc.json",
  ".luarc.jsonc",
  "composer.json",
  "Gemfile",
  "justfile",
  "Makefile",
  "package.json",
  "pubspec.yaml", -- flutter / dart
  "requirements.txt",
  "stylua.toml",
  "tsconfig.json",
}

---Look upwards dirs for a file match
---@param patterns? table
---@return string|nil root
M.get_root_by_patterns = function(patterns)
  patterns = patterns or M.PROJECT_ROOTS
  local bufname = vim.fn.bufname()
  local start = bufname ~= "" and 0 or vim.uv.cwd()
  if start == nil then
    return nil
  end
  return vim.fs.root(start, patterns)
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

  -- naively look upwards (doesn't work on complex things like worktrees or
  -- setting git workdir)
  local find_opts = vim.tbl_extend("force", {
    limit = 1,
    upward = true,
    type = "directory",
  }, opts or {})
  local res = vim.fs.find(".git", find_opts)
  local from_find = res[1] and vim.fn.fnamemodify(res[1], ":h") or nil
  if from_find then
    return from_find
  end

  local from_system = vim
    .system({ "git", "rev-parse", "--show-cdup" })
    :wait().stdout
    :gsub("\n", "")
  if from_system then
    return vim.fn.fnamemodify(from_system, ":p:h")
  end

  return nil
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
