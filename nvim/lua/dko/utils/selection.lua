local M = {}

M.get = function()
  if not vim.fn.mode():find("v") then
    return nil
  end
  vim.cmd.normal({ '"zy', bang = true })
  return vim.fn.getreg("z", false) --[[@as string]]
end

return M
