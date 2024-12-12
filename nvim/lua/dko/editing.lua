local M = {}

---@param size integer
M.space = function(size)
  vim.notify("set space mode")
  vim.bo.expandtab = true
  vim.bo.shiftwidth = size
  vim.bo.softtabstop = size
end

---@param size integer
M.tab = function(size)
  vim.notify("set tab mode")
  vim.bo.expandtab = false
  vim.bo.shiftwidth = size
  vim.bo.softtabstop = size
end

M.from_stylua_toml = function()
  local toml = vim.fs.find("stylua.toml", {
    path = vim.fn.fnamemodify(vim.api.nvim_buf_get_name(0), ":h"),
    upward = true,
    type = "file",
  })[1]
  if not toml then
    return
  end

  local filename = vim.fn.expand("%:t")
  vim.notify(
    ("Using stylua.toml settings for file:\n%s"):format(filename),
    vim.log.levels.INFO,
    { title = "dko.editing" }
  )
  for line in io.lines(toml) do
    if line:find("Spaces") then
      vim.bo.expandtab = true
    elseif line:find("Tabs") then
      vim.bo.expandtab = false
    else
      local size, count = line:gsub("indent_width.-(%d)$", "%1")
      if count > 0 then
        vim.bo.shiftwidth = tonumber(size)
        vim.bo.softtabstop = tonumber(size)
      end
    end
  end
end

return M
