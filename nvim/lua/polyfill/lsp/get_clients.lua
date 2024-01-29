return function(opts)
  return vim.lsp.get_active_clients({
    id = opts.id,
    bufnr = opts.buf,
    name = opts.name,
  })
end
