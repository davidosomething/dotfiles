vim.g.loaded_node_provider = false
vim.g.loaded_ruby_provider = false
vim.g.loaded_perl_provider = false
vim.g.loaded_python_provider = false -- disable python 2

-- Skips if python is not installed in a pyenv virtualenv
local findExecutable = function (paths)
  for _, path in pairs(paths) do
    local e = vim.fn.glob(vim.fn.expand(path))
    if vim.fn.empty(e) == 0 and vim.fn.executable(e) == 1 then
      return e
    end
  end
  return nil
end

-- python 3
local py3 = findExecutable({
  '$PYENV_ROOT/versions/neovim3/bin/python',
  '$ASDF_DIR/shims/python',
  '/usr/bin/python3',
})
if py3 ~= nil then
  vim.g.python3_host_prog = py3
else
  vim.g.loaded_python3_provider = 2
end
