return function (filename)
  local match = vim.fs.find(filename, {
    upward = true,
    limit = 1,
    type = "file",
  })
  if #match > 0 then
    vim.cmd.edit(match[1])
  end
end
