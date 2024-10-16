local M = {}
M.__index = M
M.name = "Resize"

M.enlarge = function(window, screen)
  if (window.x - 10) >= screen.x then
    window.x = window.x - 10
  end

  if (window.y - 10) >= screen.y then
    window.y = window.y - 10
  end

  window.w = window.w + 20
  window.h = window.h + 20

  return window
end

M.fullScreen = function(window, screen)
  window.x = screen.x
  window.y = screen.y
  window.w = screen.w
  window.h = screen.h

  return window
end

M.shrink = function(window, _)
  window.x = window.x + 10
  window.y = window.y + 10
  window.w = window.w - 20
  window.h = window.h - 20

  return window
end

M.topHalf = function(window, screen)
  window.x = screen.x
  window.y = screen.y
  window.w = screen.w
  window.h = screen.h / 2

  return window
end

M.topLeftHalf = function(window, screen)
  window.x = screen.x
  window.y = screen.y
  window.w = screen.w / 2
  window.h = screen.h / 2

  return window
end

M.topLeftThird = function(window, screen)
  window.x = screen.x
  window.y = screen.y
  window.w = screen.w / 3
  window.h = screen.h / 2

  return window
end

M.topLeftTwoThirds = function(window, screen)
  window.x = screen.x
  window.y = screen.y
  window.w = (screen.w / 3) * 2
  window.h = screen.h / 2

  return window
end

M.topRightHalf = function(window, screen)
  window.x = (screen.w / 2) + screen.x
  window.y = screen.y
  window.w = screen.w / 2
  window.h = screen.h / 2

  return window
end

M.topRightThird = function(window, screen)
  window.x = ((screen.w / 3) * 2) + screen.x
  window.y = screen.y
  window.w = screen.w / 3
  window.h = screen.h / 2

  return window
end

M.topRightTwoThirds = function(window, screen)
  window.x = (screen.w / 3) + screen.x
  window.y = screen.y
  window.w = (screen.w / 3) * 2
  window.h = screen.h / 2

  return window
end

M.topThird = function(window, screen)
  window.x = screen.x
  window.y = screen.y
  window.w = screen.w
  window.h = screen.h / 3

  return window
end

M.topTwoThirds = function(window, screen)
  window.x = screen.x
  window.y = screen.y
  window.w = screen.w
  window.h = (screen.h / 3) * 2

  return window
end

M.bottomHalf = function(window, screen)
  window.x = screen.x
  window.y = (screen.h / 2) + screen.y
  window.w = screen.w
  window.h = screen.h / 2

  return window
end

M.bottomLeftHalf = function(window, screen)
  window.x = screen.x
  window.y = (screen.h / 2) + screen.y
  window.w = screen.w / 2
  window.h = screen.h / 2

  return window
end

M.bottomLeftThird = function(window, screen)
  window.x = screen.x
  window.y = (screen.h / 2) + screen.y
  window.w = screen.w / 3
  window.h = screen.h / 2

  return window
end

M.bottomLeftTwoThirds = function(window, screen)
  window.x = screen.x
  window.y = (screen.h / 2) + screen.y
  window.w = (screen.w / 3) * 2
  window.h = screen.h / 2

  return window
end

M.bottomRightHalf = function(window, screen)
  window.x = (screen.w / 2) + screen.x
  window.y = (screen.h / 2) + screen.y
  window.w = screen.w / 2
  window.h = screen.h / 2

  return window
end

M.bottomRightThird = function(window, screen)
  window.x = ((screen.w / 3) * 2) + screen.x
  window.y = (screen.h / 2) + screen.y
  window.w = screen.w / 3
  window.h = screen.h / 2

  return window
end

M.bottomRightTwoThirds = function(window, screen)
  window.x = (screen.w / 3) + screen.x
  window.y = (screen.h / 2) + screen.y
  window.w = (screen.w / 3) * 2
  window.h = screen.h / 2

  return window
end

M.bottomThird = function(window, screen)
  window.x = screen.x
  window.y = ((screen.h / 3) * 2) + screen.y
  window.w = screen.w
  window.h = screen.h / 3

  return window
end

M.bottomTwoThirds = function(window, screen)
  window.x = screen.x
  window.y = (screen.h / 3) + screen.y
  window.w = screen.w
  window.h = (screen.h / 3) * 2

  return window
end

M.leftHalf = function(window, screen)
  window.x = screen.x
  window.y = screen.y
  window.w = screen.w / 2
  window.h = screen.h

  return window
end

M.leftThird = function(window, screen)
  window.x = screen.x
  window.y = screen.y
  window.w = screen.w / 3
  window.h = screen.h

  return window
end

M.leftTwoThirds = function(window, screen)
  window.x = screen.x
  window.y = screen.y
  window.w = (screen.w / 3) * 2
  window.h = screen.h
  return window
end

M.rightHalf = function(window, screen)
  window.x = (screen.w / 2) + screen.x
  window.y = screen.y
  window.w = screen.w / 2
  window.h = screen.h
  return window
end

M.rightThird = function(window, screen)
  window.x = (screen.w / 3) * 2 + screen.x
  window.y = screen.y
  window.w = screen.w / 3
  window.h = screen.h
  return window
end

M.rightTwoThirds = function(window, screen)
  window.x = (screen.w / 3) + screen.x
  window.y = screen.y
  window.w = (screen.w / 3) * 2
  window.h = screen.h
  return window
end

M.center = function(window, screen)
  window.x = ((screen.w - window.w) / 2) + screen.x
  window.y = ((screen.h - window.h) / 2) + screen.y
  return window
end

M.centerHalf = function(window, screen)
  local newWidth = math.floor(screen.w / 2)
  window.w = newWidth
  window.h = screen.h

  local middleOfScreen = math.floor(screen.x / 2) + math.floor(screen.w / 2)
  window.x = middleOfScreen - math.floor(newWidth / 2)
  window.y = screen.y
  return window
end

M.centerTwoThirds = function(window, screen)
  local newWidth = 2 * math.floor(screen.w / 3)
  print(newWidth)
  window.w = newWidth
  window.h = screen.h

  local middleOfScreen = math.floor(screen.x / 2) + math.floor(screen.w / 2)
  window.x = middleOfScreen - math.floor(newWidth / 2)
  window.y = screen.y
  return window
end

M.centerThird = function(window, screen)
  print("centerThird")
  local newWidth = math.floor(screen.w / 3)
  window.w = newWidth
  window.h = screen.h

  local middleOfScreen = math.floor(screen.x / 2) + math.floor(screen.w / 2)
  window.x = middleOfScreen - math.floor(newWidth / 2)
  window.y = screen.y
  return window
end

M.centerHorizontalThird = function(window, screen)
  window.x = screen.x
  window.y = screen.h / 3
  window.w = screen.w
  window.h = screen.h / 3

  return window
end

M.centerVerticalThird = function(window, screen)
  window.x = screen.w / 3
  window.y = screen.y
  window.w = screen.w / 3
  window.h = screen.h

  return window
end

return M
