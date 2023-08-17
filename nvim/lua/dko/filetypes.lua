vim.filetype.add({
  extension = {
    conf = "conf",
    env = "dotenv",
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
    -- ["env%.(%a+)"] = function(_path, _bufnr, ext)
    --   vim.print(ext)
    --   if vim.tbl_contains({ "local", "example", "dev", "prod" }, ext) then
    --     return "dotenv"
    --   end
    -- end,
  },
})

-- check ../plugins/treesitter.lua to enable ts highlighting for new filetypes
