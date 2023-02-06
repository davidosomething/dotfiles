return function()
  local cexpr = vim.fn.expand('<cexpr>')
  local fn
  if string.find(cexpr, "vim%.g%.") then
    local prefixed  = "g:" .. cexpr:gsub("vim%.g%.(.-)$", "%1")
    print('Looking up vim.g ' .. prefixed)
    vim.cmd.help(prefixed)
    return
  elseif string.find(cexpr, "vim%.o%.") then
    local quoted  = "'" .. cexpr:gsub("vim%.o%.(.-)$", "%1") .. "'"
    print('Looking up vim.o ' .. quoted)
    vim.cmd.help(quoted)
    return
  elseif string.find(cexpr, "vim%.opt%.") then
    local quoted  = "'" .. cexpr:gsub("vim%.opt%.(.-)$", "%1"):gsub("(.*):.*$", "%1") .. "'"
    print('Looking up vim.opt ' .. quoted)
    vim.cmd.help(quoted)
    return
  elseif string.find(cexpr, "vim.fn.") then
    fn = cexpr:gsub("vim%.fn%.(.-)%(.*$", "%1")
  elseif string.find(cexpr, "vim.cmd.") then
    fn = cexpr:gsub("vim%.cmd%.(.-)%(.*$", "%1")
  else
    fn = 'luaref-' .. cexpr:gsub("(.*)%(.*$","%1")
  end
  if fn ~= nil then
    print('Looking up ' .. fn)
    vim.cmd.help(fn)
  end
end
