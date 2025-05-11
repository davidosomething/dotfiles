local M = {}

local nvim_dir = ("%s/nvim"):format(vim.env.XDG_CONFIG_HOME)
local after_dir = ("%s/after"):format(nvim_dir)

-- @TODO using this because of https://github.com/neovim/nvim-lspconfig/issues/3189
-- Need to call this after plugins loaded since they change runtime files
M.get_runtime_files = function()
  return vim
    .iter(vim.api.nvim_get_runtime_file("", true))
    :filter(function(v)
      return v ~= nvim_dir and v ~= after_dir
    end)
    :totable()
end

return M
