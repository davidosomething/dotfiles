-- utils related to terminal emulator

local M = {}

M.is_docker_exec = function()
  -- yes .dockerenv is in root /
  return vim.fn.getftype("/.dockerenv") == "file"
end

M.is_remote = function()
  return vim.env.SSH_TTY ~= nil
    or M.is_docker_exec()
    or vim.env.NVIM_INSTALL_ALL ~= nil
end

return M
