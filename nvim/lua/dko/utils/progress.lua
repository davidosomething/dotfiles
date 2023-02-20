local M = {}

M.VERTICAL = { "▁", "▂", "▃", "▄", "▅", "▆", "▇", "█" }
M.HORIZONTAL = { "▏", "▎", "▍", "▌", "▋", "▊", "▉" }

---@param frames table
---@param percent number
---@return string
M.character = function(frames, percent)
  -- 17 for VERTICAL
  local frameInterval = math.ceil(100 / #frames)
  -- 0%, 0/17 = 0 -> max 1
  -- 1%, 1/17 = 0.05 -> ceil 1
  -- 30%, 30/17 = 1.76 -> 2
  -- 100%, 30/17 = 5.88 -> 6
  local frameIndex = math.max(1, math.ceil((percent or 0) / frameInterval))
  return frames[frameIndex]
end

return M
