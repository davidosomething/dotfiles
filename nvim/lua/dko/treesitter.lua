local buffer_queue = {}

local M = {}

M.filetype_to_parser = {
  dosini = "ini",
  dotenv = "bash",
  fstab = "ini",
  javascriptreact = "jsx",
  tiltfile = "starlark",
  typescriptreact = "tsx",
  udevrules = "udev",
  ["yaml.docker-compose"] = "yaml",
}
for ft, parser in pairs(M.filetype_to_parser) do
  vim.treesitter.language.register(parser, ft)
end

---@type string[] -- list of filetypes to skip parser installation
M.treesitter_ignores = {
  "checkhealth",
  "git", -- gitcommit
  "justfile",
  "lazy",
  "mason",
  "snacks",
  "snacks_dashboard",
  "snacks_notif",
  "snacks_picker_input",
  "snacks_win",
  "toggleterm",
}

M.enqueue = function(bufnr)
  buffer_queue[bufnr] = true
end

M.flush = function()
  for bufnr, _ in pairs(buffer_queue) do
    if vim.api.nvim_buf_is_valid(bufnr) then
      local filetype = vim.bo[bufnr]["filetype"]
      require("nvim-treesitter").install(filetype):await(M.bind_buffer)
    end
  end
end

M.bind_buffer = function()
  vim.wo[0][0].foldexpr = "v:lua.vim.treesitter.foldexpr()"
  vim.wo[0][0].foldmethod = "expr"
  vim.bo.indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
  vim.treesitter.start()
end

return M
