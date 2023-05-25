return function(filename)
  local match = vim.fs.find(filename, {
    upward = true,
    limit = 1,
    type = "file",
    -- need to specify closest to current file or else cwd is used
    path = vim.fs.dirname(vim.api.nvim_buf_get_name(0)),
  })
  if #match > 0 then
    vim.cmd.edit(match[1])
  end
end
