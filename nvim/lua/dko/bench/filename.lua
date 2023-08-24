-- benchmark vim.fn.fnamemodify vs vim.fs.basename

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
    vim.fn.fnamemodify("~/.dotfiles/README.md", ":t")
  end)
end
local fn = avg(times)

times = {}
for j = 1, runs, 1 do
  times[j] = b(function()
    vim.fs.basename("~/.dotfiles/README.md")
  end)
end
local fs = avg(times)

vim.print(fn > fs and "fs is faster" or "fn is faster")
