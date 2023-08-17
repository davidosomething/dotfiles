vim.filetype.add({
  extension = {
    conf = "conf",
    tiltfile = "tiltfile",
    Tiltfile = "tiltfile",
  },
  filename = {
    [".env"] = "dotenv",
    ["tsconfig.json"] = "jsonc",
    [".yamlfmt"] = "yaml",
  },
  pattern = {
    ["%.env%.[%w_.-]+"] = "dotenv",
  },
})

-- check ../plugins/treesitter.lua to enable ts highlighting for new filetypes
