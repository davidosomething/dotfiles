return function(filename)
  local match = vim.fs.find(filename, {
    -- need to specify closest to current file or else cwd is used
    path = vim.fs.dirname(vim.api.nvim_buf_get_name(0)),
    upward = true,
    type = "file",
  })
  if #match > 0 then
    vim.cmd.edit(match[1])
  end
end
