vim.filetype.add({
  extension = {
    conf = "conf",
    env = "dotenv",
    mdx = "mdx",
    tiltfile = "tiltfile",
    Tiltfile = "tiltfile",

    -- quadlets
    container = "systemd",
    volume = "systemd",
  },
  filename = {
    -- dotfiles do not count as extensions, they are exact filename only
    [".dockerignore"] = "gitignore",
    [".env"] = "dotenv",
    [".eslintrc.json"] = "jsonc",
    [".ignore"] = "gitignore",
    [".nxignore"] = "gitignore",
    [".yamlfmt"] = "yaml",
    [".yamllint"] = "yaml",
    ["project.json"] = "jsonc", -- assuming nx project.json
  },
  pattern = {
    ["compose.y.?ml"] = "yaml.docker-compose",
    ["docker%-compose%.y.?ml"] = "yaml.docker-compose",
    ["[%w_.-]*%.gitconfig"] = "gitconfig",
    ["%.env%.[%w_.-]+"] = "dotenv",
    ["tsconfig%."] = "jsonc",
    -- ["env%.(%a+)"] = function(_path, _bufnr, ext)
    --   vim.print(ext)
    --   if vim.list_contains({ "local", "example", "dev", "prod" }, ext) then
    --     return "dotenv"
    --   end
    -- end,
  },
})

-- check filetype_to_parser in ./treesitter.lua for treesitter syntax mappings
