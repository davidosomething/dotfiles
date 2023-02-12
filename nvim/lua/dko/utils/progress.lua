local M = {}

---@alias Frame string

---@class FrameConfig
---@field frame Frame
---@field min number
---@field max number

---@type FrameConfig[]
local states = {
  { frame = " ", min = 0, max = 0 },
  { frame = "▁", min = 1, max = 9 },
  { frame = "▃", min = 10, max = 39 },
  { frame = "▄", min = 40, max = 69 }, -- nice
  { frame = "▅", min = 70, max = 79 },
  { frame = "▆", min = 80, max = 89 },
  { frame = "▇", min = 90, max = 100 },
}

---@param percent number
---@return Frame
M.vertical_character = function(percent)
  ---@param frameConfig FrameConfig
  ---@return boolean
  local function frameFilter(frameConfig)
    return percent >= frameConfig.min and percent <= frameConfig.max
  end

  local filteredTable = vim.tbl_filter(frameFilter, states)

  -- Fallback to empty
  return #filteredTable and filteredTable[1].frame or states[1].frame
end

return M
