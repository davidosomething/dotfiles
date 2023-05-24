vim.filetype.add({
  extension = {
    conf = 'conf',
    tiltfile = 'tiltfile',
    Tiltfile = 'tiltfile',
  },
  filename = {
    ['Tiltfile'] = 'tiltfile',
    ['.env'] = 'dotenv',
    ['.env.development'] = 'dotenv',
    ['.env.local'] = 'dotenv',
    ['.env.localkube'] = 'dotenv',
    ['.env.production'] = 'dotenv',
    ['tsconfig.json'] = 'jsonc',
    ['.yamlfmt'] = 'yaml',
  }
})

-- check ../plugins/treesitter.lua to enable ts highlighting for new filetypes
