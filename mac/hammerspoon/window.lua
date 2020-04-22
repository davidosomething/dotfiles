---
-- Spectacle.app style window management
-- https://github.com/scottwhudson/Lunette
hs.loadSpoon("Lunette")
spoon.Lunette:bindHotkeys({
  leftHalf = {
    {hyper, "H"},
  },
  rightHalf = {
    {hyper, "L"},
  },
  topHalf = {
    {hyper, "K"},
  },
  bottomHalf = {
    {hyper, "J"},
  },
  topLeft = false,
  topRight = false,
  bottomLeft = false,
  bottomRight = false,
  fullScreen = {
    {hyper, "F"},
  },
  center = false,
  nextThird = false,
  prevThird = false,
  enlarge = {
    {hyper, "up"},
  },
  shrink = {
    {hyper, "down"},
  },
  undo = {
    {hyper, "Z"},
  },
  redo = {
    {hyper, "Y"},
  },
  nextDisplay = false,
  prevDisplay = false,
})

hs.hotkey.bind(hyper, ']', function()
  -- get the focused window
  local win = hs.window.focusedWindow()
  -- get the screen where the focused window is displayed, a.k.a. current screen
  local screen = win:screen()
  -- compute the unitRect of the focused window relative to the current screen
  -- and move the window to the next screen setting the same unitRect 
  win:move(win:frame():toUnitRect(screen:frame()), screen:next(), true, 0)
end)

hs.hotkey.bind(hyper, '[', function()
  -- get the focused window
  local win = hs.window.focusedWindow()
  -- get the screen where the focused window is displayed, a.k.a. current screen
  local screen = win:screen()
  -- compute the unitRect of the focused window relative to the current screen
  -- and move the window to the next screen setting the same unitRect 
  win:move(win:frame():toUnitRect(screen:frame()), screen:previous(), true, 0)
end)
