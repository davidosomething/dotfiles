-- utils related to terminal emulator

local M = {}

M.is_remote = function()
  local is_remote = vim.env.SSH_CLIENT or vim.uv.fs_stat("/.dockerenv")
  -- yes .dockerenv is in root /
  return (is_remote and (vim.env.DISPLAY == nil or vim.env.DISPLAY == ""))
    or vim.env.NVIM_INSTALL_ALL
end

return M
