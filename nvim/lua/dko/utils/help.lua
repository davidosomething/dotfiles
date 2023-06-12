local M = {}

M.find = function(haystack)
  if not haystack then
    return nil
  end

  local match

  if haystack:find("vim%.g%.") then
    match = ("g:%s"):format(haystack:gsub("vim%.g%.(.-)$", "%1"))
    return { group = "vim.g", haystack = haystack, match = match }
  end

  if haystack:find("vim%.[o|opt]%.") then
    vim.print('vim.o/opt')
    match = ("'%s'"):format(
      haystack:gsub("vim%.[o|opt]%.(.-)$", "%1"):gsub("(.*):.*$", "%1")
    )
    return { group = "vim.opt", haystack = haystack, match = match }
  end

  if haystack:find("vim%.[b|g|t|w]?o%.") then
    match = ("'%s'"):format(haystack:gsub("vim%.[b|g|t|w]o%.(.-)$", "%1"))
    return { group = "vim.b|g|t|w", haystack = haystack, match = match }
  end

  if haystack:find("vim%.[loop|uv]") then
    -- vim.uv.this(abc) -> uv.this
    match = haystack:gsub("vim%..-%.(.*)", "%1")
    match = match:gsub("(.*)%(.*", "uv.%1")
    return { group = "vim.loop|uv", haystack = haystack, match = match }
  end

  if haystack:find("vim%.[cmd|fn|nvim]") then
    -- vim.xyz.this(abc) -> this
    match = haystack:gsub("vim%..-%.(.*)", "%1")
    match = match:gsub("(.*)%(.*", "%1")
    return { group = "vim.cmd|fn", haystack = haystack, match = match }
  end

  if haystack:find("vim%.api%.nvim") then
    match = haystack:gsub("vim%.api%.(.-)$", "%1")
    return { group = "vim.api.nvim*", haystack = haystack, match = match }
  end

  if haystack:find("vim%.[api|diagnostic|keymap|lsp]") then
    -- vim.xyz.this(abc) -> vim.xyz.this
    match = haystack:gsub("(vim%..-)%(.*$", "%1")
    return {
      group = "vim.api|diagnostic|keymap|lsp",
      haystack = haystack,
      match = match,
    }
  end

  if haystack:find("[string|table]%.") then
    -- string.xyz(abc) -> string.xyz
    match = haystack:gsub("(%a%..-)%(.*$", "%1")
    return { group = "lua builtin", haystack = haystack, match = match }
  end

  if vim.bo.filetype == "lua" then
    match = "luaref-" .. haystack:gsub("(.*)%(.*$", "%1")
    return { group = "luaref", haystack = haystack, match = match }
  end

  return { group = "fallback", haystack = haystack, match = haystack }
end

return M
