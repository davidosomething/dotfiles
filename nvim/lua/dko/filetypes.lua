vim.filetype.add({
  extension = {
    conf = "conf",
    env = "dotenv",
    tiltfile = "tiltfile",
    Tiltfile = "tiltfile",

    -- quadlets
    container = "systemd",
    volume = "systemd",
  },
  filename = {
    [".dockerignore"] = "gitignore",
    [".env"] = "dotenv",
    [".eslintrc.json"] = "jsonc",
    [".ignore"] = "gitignore",
    [".yamlfmt"] = "yaml",
    [".yamllint"] = "yaml",
    ["project.json"] = "jsonc", -- assuming nx project.json
  },
  pattern = {
    ["compose.y.?ml"] = "yaml.docker-compose",
    ["docker%-compose%.y.?ml"] = "yaml.docker-compose",
    ["%.env%.[%w_.-]+"] = "dotenv",
    ["tsconfig%."] = "jsonc",
    -- ["env%.(%a+)"] = function(_path, _bufnr, ext)
    --   vim.print(ext)
    --   if vim.tbl_contains({ "local", "example", "dev", "prod" }, ext) then
    --     return "dotenv"
    --   end
    -- end,
  },
})

-- check ./plugins/treesitter.lua to enable ts highlighting for new filetypes
