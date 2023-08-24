-- benchmark os.getenv() vs vim.uv.os_getenv() vs vim.fn.expand()

local RUNS = 10000

---@param callback fun()
local function b(callback)
  local start_time = vim.fn.reltime() --[[@as number]]
  callback()
  local elapsed_time = vim.fn.reltime(vim.fn.reltime(start_time))
  return elapsed_time[2]
end

local function avg(times)
  local sum = vim.iter(times):fold(0, function(t, v)
    return t + v
  end)
  return sum / RUNS
end

local times = {}
for j = 1, RUNS, 1 do
  times[j] = b(function()
    os.getenv("DOTFILES")
  end)
end
local osres = avg(times)

times = {}
for j = 1, RUNS, 1 do
  times[j] = b(function()
    vim.uv.os_getenv("DOTFILES")
  end)
end
local uvres = avg(times)

times = {}
for j = 1, RUNS, 1 do
  times[j] = b(function()
    vim.fn.expand("$DOTFILES")
  end)
end
local expandres = avg(times)

vim.print({
  osres = osres,
  uvres = uvres,
  expandres = expandres,
})
