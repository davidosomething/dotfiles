local M = {}

M.cexpr = function(haystack)
  if not haystack then
    return nil
  end

  local match

  if haystack:find("vim%.g%.") then
    match = ("g:%s"):format(haystack:gsub("vim%.g%.(.-)$", "%1"))
    vim.notify("match g")
    return { group = "vim.g", haystack = haystack, match = match }
  end

  if haystack:find("vim%.[o|opt]%.") then
    vim.print("vim.o/opt")
    match = ("'%s'"):format(
      haystack:gsub("vim%.[o|opt]%.(.-)$", "%1"):gsub("(.*):.*$", "%1")
    )
    vim.notify("match oopt")
    return { group = "vim.opt", haystack = haystack, match = match }
  end

  if haystack:find("vim%.[b|g|t|w]?o%.") then
    match = ("'%s'"):format(haystack:gsub("vim%.[b|g|t|w]o%.(.-)$", "%1"))
    vim.notify("match bgtwo")
    return { group = "vim.b|g|t|w", haystack = haystack, match = match }
  end

  if haystack:find("vim%.loop") or haystack:find("vim%.uv") then
    -- vim.uv.this(abc) -> uv.this
    match = haystack:gsub("vim%..-%.(.*)", "%1")
    match = match:gsub("(.*)%(.*", "uv.%1")
    vim.notify("match lu")
    return { group = "vim.loop|uv", haystack = haystack, match = match }
  end

  if
    haystack:find("vim%.cmd")
    or haystack:find("vim%.fn")
    or haystack:find("vim%.nvim")
  then
    -- vim.xyz.this(abc) -> this
    match = haystack:gsub("vim%..-%.(.*)", "%1")
    match = match:gsub("(.*)%(.*", "%1")
    vim.notify("match cfn")
    return { group = "vim.cmd|fn", haystack = haystack, match = match }
  end

  if haystack:find("vim%.api%.nvim") then
    match = haystack:gsub("vim%.api%.(.-)$", "%1")
    vim.notify("match api.nvim")
    return { group = "vim.api.nvim*", haystack = haystack, match = match }
  end

  if
    haystack:find("vim%.api")
    or haystack:find("vim%.diagnostic")
    or haystack:find("vim%.keymap")
    or haystack:find("vim%.lsp")
  then
    -- vim.xyz.this(abc) -> vim.xyz.this
    match = haystack:gsub("(vim%..-)%(.*$", "%1")
    vim.notify("match adkl")
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

M.line = function(haystack)
  if not haystack then
    return nil
  end

  local match

  if haystack:find("autocmd%(") then
    match = haystack:match([[autocmd."([^"]+)"]])
    if match then
      vim.notify("match autocmd")
      return { group = "autocmd", haystack = haystack, match = match }
    end
  end

  return nil
end

return M
