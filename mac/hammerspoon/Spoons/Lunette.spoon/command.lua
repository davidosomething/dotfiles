-- luacheck: globals hs Validate Resize
local M = {}
M.__index = M
M.name = "Command"

-- Load dependencies
local function script_path()
  local str = debug.getinfo(2, "S").source:sub(2)
  return str:match("(.*/)")
end
M.spoonPath = script_path()

Validate = dofile(M.spoonPath .. "/validator.lua")
Resize = dofile(M.spoonPath .. "/resize.lua")

M.cycleWidth = function(window, screen)
  -- e.g. when window is 900px wide out of 1080px screen ~= 8.3
  local windowAsPercentOfScreen = (window.w / screen.w) * 10
  -- 8.3 -> 8 (your 900px wide screen is roughly 80%)
  local nearestTenthPercent = math.floor(windowAsPercentOfScreen)
  local nextTenthPercent = nearestTenthPercent + 1
  if nextTenthPercent > 10 then
    nextTenthPercent = 1
  end
  local nextWindowWidth = (screen.w / 10) * nextTenthPercent
  if window.x + nextWindowWidth > screen.w then
    window.x = screen.w - nextWindowWidth
  end
  window.w = nextWindowWidth
  return window
end

M.leftHalf = function(windowFrame, screenFrame)
  if Validate.leftHalf(windowFrame, screenFrame) then
    return Resize.leftTwoThirds(windowFrame, screenFrame)
  end
  if Validate.leftTwoThirds(windowFrame, screenFrame) then
    return Resize.leftThird(windowFrame, screenFrame)
  end
  return Resize.leftHalf(windowFrame, screenFrame)
end

M.fullScreen = function(windowFrame, screenFrame)
  return Resize.fullScreen(windowFrame, screenFrame)
end

M.center = function(windowFrame, screenFrame)
  if Validate.centerHalf(windowFrame, screenFrame) then
    print("validated center half")
    return Resize.centerTwoThirds(windowFrame, screenFrame)
  end
  if Validate.centerTwoThirds(windowFrame, screenFrame) then
    print("validated center 2/3s")
    return Resize.centerThird(windowFrame, screenFrame)
  end
  print("validated center nothing")
  return Resize.centerHalf(windowFrame, screenFrame)
end

M.topHalf = function(windowFrame, screenFrame)
  if Validate.topHalf(windowFrame, screenFrame) then
    return Resize.topTwoThirds(windowFrame, screenFrame)
  end
  if Validate.topTwoThirds(windowFrame, screenFrame) then
    return Resize.topThird(windowFrame, screenFrame)
  end
  return Resize.topHalf(windowFrame, screenFrame)
end

M.bottomHalf = function(windowFrame, screenFrame)
  if Validate.bottomHalf(windowFrame, screenFrame) then
    return Resize.bottomTwoThirds(windowFrame, screenFrame)
  end
  if Validate.bottomTwoThirds(windowFrame, screenFrame) then
    return Resize.bottomThird(windowFrame, screenFrame)
  end
  return Resize.bottomHalf(windowFrame, screenFrame)
end

M.topLeft = function(windowFrame, screenFrame)
  if Validate.topLeftHalf(windowFrame, screenFrame) then
    return Resize.topLeftTwoThirds(windowFrame, screenFrame)
  end
  if Validate.topLeftTwoThirds(windowFrame, screenFrame) then
    return Resize.topLeftThird(windowFrame, screenFrame)
  end
  return Resize.topLeftHalf(windowFrame, screenFrame)
end

M.topRight = function(windowFrame, screenFrame)
  if Validate.topRightHalf(windowFrame, screenFrame) then
    return Resize.topRightTwoThirds(windowFrame, screenFrame)
  end
  if Validate.topRightTwoThirds(windowFrame, screenFrame) then
    return Resize.topRightThird(windowFrame, screenFrame)
  end
  return Resize.topRightHalf(windowFrame, screenFrame)
end

M.bottomRight = function(windowFrame, screenFrame)
  if Validate.bottomRightHalf(windowFrame, screenFrame) then
    return Resize.bottomRightTwoThirds(windowFrame, screenFrame)
  end
  if Validate.bottomRightTwoThirds(windowFrame, screenFrame) then
    return Resize.bottomRightThird(windowFrame, screenFrame)
  end
  return Resize.bottomRightHalf(windowFrame, screenFrame)
end

M.bottomLeft = function(windowFrame, screenFrame)
  if Validate.bottomLeftHalf(windowFrame, screenFrame) then
    return Resize.bottomLeftTwoThirds(windowFrame, screenFrame)
  end
  if Validate.bottomLeftTwoThirds(windowFrame, screenFrame) then
    return Resize.bottomLeftThird(windowFrame, screenFrame)
  end
  return Resize.bottomLeftHalf(windowFrame, screenFrame)
end

M.rightHalf = function(windowFrame, screenFrame)
  if Validate.rightHalf(windowFrame, screenFrame) then
    return Resize.rightTwoThirds(windowFrame, screenFrame)
  end
  if Validate.rightTwoThirds(windowFrame, screenFrame) then
    return Resize.rightThird(windowFrame, screenFrame)
  end
  return Resize.rightHalf(windowFrame, screenFrame)
end

M.enlarge = function(windowFrame, screenFrame)
  return Resize.enlarge(windowFrame, screenFrame)
end

M.shrink = function(windowFrame, screenFrame)
  return Resize.shrink(windowFrame, screenFrame)
end

M.nextThird = function(windowFrame, screenFrame)
  if Validate.leftThird(windowFrame, screenFrame) then
    return Resize.centerVerticalThird(windowFrame, screenFrame)
  end
  if Validate.centerVerticalThird(windowFrame, screenFrame) then
    return Resize.rightThird(windowFrame, screenFrame)
  end
  if Validate.rightThird(windowFrame, screenFrame) then
    return Resize.topThird(windowFrame, screenFrame)
  end
  if Validate.topThird(windowFrame, screenFrame) then
    return Resize.centerHorizontalThird(windowFrame, screenFrame)
  end
  if Validate.centerHorizontalThird(windowFrame, screenFrame) then
    return Resize.bottomThird(windowFrame, screenFrame)
  end
  return Resize.leftThird(windowFrame, screenFrame)
end

M.prevThird = function(windowFrame, screenFrame)
  if Validate.leftThird(windowFrame, screenFrame) then
    return Resize.bottomThird(windowFrame, screenFrame)
  end
  if Validate.bottomThird(windowFrame, screenFrame) then
    return Resize.centerHorizontalThird(windowFrame, screenFrame)
  end
  if Validate.centerHorizontalThird(windowFrame, screenFrame) then
    return Resize.topThird(windowFrame, screenFrame)
  end
  if Validate.topThird(windowFrame, screenFrame) then
    return Resize.rightThird(windowFrame, screenFrame)
  end
  if Validate.rightThird(windowFrame, screenFrame) then
    return Resize.centerVerticalThird(windowFrame, screenFrame)
  end
  return Resize.leftThird(windowFrame, screenFrame)
end

return M
