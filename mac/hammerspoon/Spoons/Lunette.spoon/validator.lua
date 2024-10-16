local M = {}
M.__index = M
M.name = "Validator"

M.approxHalf = function(a, b)
  local ratio = a / b
  return ratio > 0.45 and ratio < 0.55
end

M.approxTwoThirds = function(a, b)
  local ratio = a / b
  return ratio > 0.60 and ratio < 0.70
end

M.topHalf = function(window, screen)
  return window.x == screen.x
    and window.y == screen.y
    and window.w == screen.w
    and window.h == (screen.h / 2)
end

M.topThird = function(window, screen)
  return window.x == screen.x
    and window.y == screen.y
    and window.w == screen.w
    and math.floor(window.h) == math.floor(screen.h / 3)
end

M.topTwoThirds = function(window, screen)
  return window.x == screen.x
    and window.y == screen.y
    and window.w == screen.w
    and math.floor(window.h) == math.floor((screen.h / 3) * 2)
end

M.topLeftHalf = function(window, screen)
  return window.x == screen.x
    and window.y == screen.y
    and window.w == screen.w / 2
    and window.h == screen.h / 2
end

M.topLeftThird = function(window, screen)
  return window.x == screen.x
    and window.y == screen.y
    and math.floor(window.w) == math.floor(screen.w / 3)
    and window.h == screen.h / 2
end

M.topLeftTwoThirds = function(window, screen)
  return window.x == screen.x
    and window.y == screen.y
    and math.floor(window.w) == math.floor((screen.w / 3) * 2)
    and window.h == screen.h / 2
end

M.topRightHalf = function(window, screen)
  return window.x == (screen.w / 2) + screen.x
    and window.y == screen.y
    and window.w == screen.w / 2
    and window.h == screen.h / 2
end

M.topRightThird = function(window, screen)
  return math.floor(window.x) == math.floor(((screen.w / 3) * 2) + screen.x)
    and window.y == screen.y
    and math.floor(window.w) == math.floor(screen.w / 3)
    and window.h == screen.h / 2
end

M.topRightTwoThirds = function(window, screen)
  return math.floor(window.x) == math.floor((screen.w / 3) + screen.x)
    and window.y == screen.y
    and math.floor(window.w) == math.floor((screen.w / 3) * 2)
    and window.h == screen.h / 2
end

M.bottomHalf = function(window, screen)
  return window.x == screen.x
    and window.y == (screen.h / 2) + screen.y
    and window.w == screen.w
    and window.h == screen.h / 2
end

M.bottomThird = function(window, screen)
  return window.x == screen.x
    and math.floor(window.y) == math.floor(((screen.h / 3) * 2) + screen.y)
    and window.w == screen.w
    and math.floor(window.h) == math.floor(screen.h / 3)
end

M.bottomTwoThirds = function(window, screen)
  return window.x == screen.x
    and math.floor(window.y) == math.floor((screen.h / 3) + screen.y)
    and window.w == screen.w
    and math.floor(window.h) == math.floor((screen.h / 3) * 2)
end

M.bottomLeftHalf = function(window, screen)
  return window.x == screen.x
    and window.y == screen.h / 2
    and window.w == screen.w / 2
    and window.h == screen.h / 2
end

M.bottomLeftThird = function(window, screen)
  return window.x == screen.x
    and window.y == screen.h / 2
    and math.floor(window.w) == math.floor(screen.w / 3)
    and window.h == screen.h / 2
end

M.bottomLeftTwoThirds = function(window, screen)
  return window.x == screen.x
    and window.y == screen.h / 2
    and math.floor(window.w) == math.floor((screen.w / 3) * 2)
    and window.h == screen.h / 2
end

M.bottomRightThird = function(window, screen)
  return math.floor(window.x) == math.floor((screen.w / 3) * 2)
    and window.y == screen.h / 2
    and math.floor(window.w) == math.floor(screen.w / 3)
    and window.h == screen.h / 2
end

M.bottomRightTwoThirds = function(window, screen)
  return math.floor(window.x) == math.floor(screen.w / 3)
    and window.y == screen.h / 2
    and math.floor(window.w) == math.floor((screen.w / 3) * 2)
    and window.h == screen.h / 2
end

M.bottomRightHalf = function(window, screen)
  return window.x == (screen.w / 2) + screen.x
    and window.y == (screen.h / 2) + screen.y
    and window.w == screen.w / 2
    and window.h == screen.h / 2
end

M.leftHalf = function(window, screen)
  return window.x == screen.x and M.approxHalf(window.w, screen.w)
end

M.leftThird = function(window, screen)
  return window.x == screen.x
    and math.floor(window.w) == math.floor(screen.w / 3)
end

M.leftTwoThirds = function(window, screen)
  return window.x == screen.x and M.approxTwoThirds(window.w, screen.w)
end

M.rightHalf = function(window, screen)
  return window.x == (screen.w / 2) + screen.x
    and M.approxHalf(window.w, screen.w)
end

M.rightThird = function(window, screen)
  return math.floor(window.x) == math.floor((screen.w / 3) * 2 + screen.x)
    and math.floor(window.w) == math.floor(screen.w / 3)
end

M.rightTwoThirds = function(window, screen)
  return math.floor(window.x) == math.floor((screen.w / 3) + screen.x)
    and M.approxTwoThirds(window.w, screen.w)
end

M.centerHalf = function(window, screen)
  local middleOfScreen = math.floor(screen.x / 2) + math.floor(screen.w / 2)
  local isHalfWidth = window.w == math.floor(screen.w / 2)
  local isCentered = window.x == middleOfScreen - math.floor(window.w / 2)
  return isHalfWidth and isCentered
end

M.centerTwoThirds = function(window, screen)
  local result = M.approxTwoThirds(window.w, screen.w)
  print(result and "center 2/3s" or "not center 2/3s")
  return result
end

M.centerHorizontalThird = function(window, screen)
  return window.x == screen.x
    and math.floor(window.y) == math.floor(screen.h / 3)
    and window.w == screen.w
    and math.floor(window.h) == math.floor(screen.h / 3)
end

M.centerVerticalThird = function(window, screen)
  return math.floor(window.x) == math.floor(screen.w / 3)
    and window.y == screen.y
    and math.floor(window.w) == math.floor(screen.w / 3)
    and window.h == screen.h
end

M.inScreenBounds = function(window, screen)
  return math.floor(window.w) <= math.floor(screen.w)
    and math.floor(window.h) <= math.floor(screen.h)
end

return M
