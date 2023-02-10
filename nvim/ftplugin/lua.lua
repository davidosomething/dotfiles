-- ftplugin/lua.lua

vim.fn["dko#TwoSpace"]()
vim.o.wrap = false

vim.keymap.set("n", "<A-=>", function()
  vim.lsp.buf.format({
    async = false,
    name = "null-ls",
    --[[ filter = function(client)
        return client.name == 'null-ls'
      end, ]]
  })
end, { desc = "Format with null-ls builtin stylua" })
