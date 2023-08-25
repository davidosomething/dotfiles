-- benchmark vim.fn.filereadable vs vim.uv.fs_stat

---@param callback fun()
local function b(callback)
  local start_time = vim.fn.reltime() --[[@as number]]
  callback()
  local elapsed_time = vim.fn.reltime(vim.fn.reltime(start_time))
  return elapsed_time[2]
end

local runs = 10000

local function avg(times)
  local sum = vim.iter(times):fold(0, function(t, v)
    return t + v
  end)
  return sum / runs
end

local times = {}
for j = 1, runs, 1 do
  times[j] = b(function()
    vim.uv.fs_stat("~/.dotfiles/README.md")
  end)
end
local uv = avg(times)

times = {}
for j = 1, runs, 1 do
  times[j] = b(function()
    vim.fn.filereadable("~/.dotfiles/README.md")
  end)
end
local fn = avg(times)

vim.print(uv > fn and "fn is faster" or "uv is faster")
-- uv is faster 2023-08-25
