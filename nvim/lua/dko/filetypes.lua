vim.filetype.add({
  extension = {
    conf = 'conf',
    tiltfile = 'tiltfile',
  },
  filename = {
    ['Tiltfile'] = 'tiltfile',
    ['.env'] = 'dotenv',
    ['.env.development'] = 'dotenv',
    ['.env.local'] = 'dotenv',
    ['.env.localkube'] = 'dotenv',
    ['.env.production'] = 'dotenv',
    ['tsconfig.json'] = 'jsonc',
  }
})

-- check ../plugins/treesitter.lua to enable ts highlighting for new filetypes
