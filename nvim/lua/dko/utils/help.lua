return function()
  local cexpr = vim.fn.expand("<cexpr>")
  local match
  if string.find(cexpr, "vim%.g%.") then
    local prefixed = "g:" .. cexpr:gsub("vim%.g%.(.-)$", "%1")
    print("Looking up vim.g " .. prefixed)
    vim.cmd.help(prefixed)
    return
  elseif string.find(cexpr, "vim%.[b|g|t|w]?o%.") then
    match = "'" .. cexpr:gsub("vim%.[b|g|t|w]o%.(.-)$", "%1") .. "'"
  elseif string.find(cexpr, "vim%.opt%.") then
    match = "'"
      .. cexpr:gsub("vim%.opt%.(.-)$", "%1"):gsub("(.*):.*$", "%1")
      .. "'"
  elseif string.find(cexpr, "vim%.[cmd|fn]") then
    -- vim.xyz.this(abc) -> this
    match = cexpr:gsub("vim%..-%.(.*)", "%1")
    match = match:gsub("(.*)%(.*", "%1")
  elseif string.find(cexpr, "vim%.[api|diagnostic|keymap|lsp]") then
    -- vim.xyz.this(abc) -> vim.xyz.this
    match = cexpr:gsub("(vim%..-)%(.*$", "%1")
  elseif string.find(cexpr, "string%.") then
    -- string.xyz(abc) -> string.xyz
    match = cexpr:gsub("(%a%..-)%(.*$", "%1")
  else
    match = "luaref-" .. cexpr:gsub("(.*)%(.*$", "%1")
  end
  if match ~= nil then
    print("Looking up " .. match)
    vim.cmd.help(match)
  end
end
