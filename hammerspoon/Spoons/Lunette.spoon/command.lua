-- luacheck: globals hs Validate Resize
local obj = {}
obj.__index = obj
obj.name = "Command"

-- Load dependencies
local function script_path()
  local str = debug.getinfo(2, "S").source:sub(2)
  return str:match("(.*/)")
end
obj.spoonPath = script_path()

Validate = dofile(obj.spoonPath.."/validator.lua")
Resize = dofile(obj.spoonPath.."/resize.lua")

function obj.leftHalf(windowFrame, screenFrame)
  if Validate.leftHalf(windowFrame, screenFrame) then
    return Resize.leftTwoThirds(windowFrame, screenFrame)
  end
  if Validate.leftTwoThirds(windowFrame, screenFrame) then
    return Resize.leftThird(windowFrame, screenFrame)
  end
  return Resize.leftHalf(windowFrame, screenFrame)
end

function obj.fullScreen(windowFrame, screenFrame)
  return Resize.fullScreen(windowFrame, screenFrame)
end

function obj.center(windowFrame, screenFrame)
  return Resize.center(windowFrame, screenFrame)
end

function obj.topHalf(windowFrame, screenFrame)
  if Validate.topHalf(windowFrame, screenFrame) then
    return Resize.topTwoThirds(windowFrame, screenFrame)
  end
  if Validate.topTwoThirds(windowFrame, screenFrame) then
    return Resize.topThird(windowFrame, screenFrame)
  end
  return Resize.topHalf(windowFrame, screenFrame)
end

function obj.bottomHalf(windowFrame, screenFrame)
  if Validate.bottomHalf(windowFrame, screenFrame) then
    return Resize.bottomTwoThirds(windowFrame, screenFrame)
  end
  if Validate.bottomTwoThirds(windowFrame, screenFrame) then
    return Resize.bottomThird(windowFrame, screenFrame)
  end
  return Resize.bottomHalf(windowFrame, screenFrame)
end

function obj.topLeft(windowFrame, screenFrame)
  if Validate.topLeftHalf(windowFrame, screenFrame) then
    return Resize.topLeftTwoThirds(windowFrame, screenFrame)
  end
  if Validate.topLeftTwoThirds(windowFrame, screenFrame) then
    return Resize.topLeftThird(windowFrame, screenFrame)
  end
  return Resize.topLeftHalf(windowFrame, screenFrame)
end

function obj.topRight(windowFrame, screenFrame)
  if Validate.topRightHalf(windowFrame, screenFrame) then
    return Resize.topRightTwoThirds(windowFrame, screenFrame)
  end
  if Validate.topRightTwoThirds(windowFrame, screenFrame) then
    return Resize.topRightThird(windowFrame, screenFrame)
  end
  return Resize.topRightHalf(windowFrame, screenFrame)
end

function obj.bottomRight(windowFrame, screenFrame)
  if Validate.bottomRightHalf(windowFrame, screenFrame) then
    return Resize.bottomRightTwoThirds(windowFrame, screenFrame)
  end
  if Validate.bottomRightTwoThirds(windowFrame, screenFrame) then
    return Resize.bottomRightThird(windowFrame, screenFrame)
  end
  return Resize.bottomRightHalf(windowFrame, screenFrame)
end

function obj.bottomLeft(windowFrame, screenFrame)
  if Validate.bottomLeftHalf(windowFrame, screenFrame) then
    return Resize.bottomLeftTwoThirds(windowFrame, screenFrame)
  end
  if Validate.bottomLeftTwoThirds(windowFrame, screenFrame) then
    return Resize.bottomLeftThird(windowFrame, screenFrame)
  end
  return Resize.bottomLeftHalf(windowFrame, screenFrame)
end

function obj.rightHalf(windowFrame, screenFrame)
  if Validate.rightHalf(windowFrame, screenFrame) then
    return Resize.rightTwoThirds(windowFrame, screenFrame)
  end
  if Validate.rightTwoThirds(windowFrame, screenFrame) then
    return Resize.rightThird(windowFrame, screenFrame)
  end
  return Resize.rightHalf(windowFrame, screenFrame)
end

function obj.enlarge(windowFrame, screenFrame)
  return Resize.enlarge(windowFrame, screenFrame)
end

function obj.shrink(windowFrame, screenFrame)
  return Resize.shrink(windowFrame, screenFrame)
end


function obj.nextThird(windowFrame, screenFrame)
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

function obj.prevThird(windowFrame, screenFrame)
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

function obj.nextDisplay(windowFrame, _)
  local currentWindow = hs.window.focusedWindow()
  local currentScreen = currentWindow:screen()
  local nextScreen = currentScreen:next()
  local nextScreenFrame = nextScreen:frame()

  if Validate.inScreenBounds(windowFrame, nextScreenFrame) then
    return Resize.center(windowFrame, nextScreenFrame)
  end
  return Resize.fullScreen(windowFrame, nextScreenFrame)
end

function obj.prevDisplay(windowFrame, _)
  local currentWindow = hs.window.focusedWindow()
  local currentScreen = currentWindow:screen()
  local prevScreen = currentScreen:previous()
  local prevScreenFrame = prevScreen:frame()

  if Validate.inScreenBounds(windowFrame, prevScreenFrame) then
    return Resize.center(windowFrame, prevScreenFrame)
  end
  return Resize.fullScreen(windowFrame, prevScreenFrame)
end

return obj
