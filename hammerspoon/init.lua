-- ---------------------------------------------------------------------------
-- init.lua
-- ---------------------------------------------------------------------------

-- luacheck: globals hs spoon

---
-- type what is in the clipboard
hs.hotkey.bind({"cmd", "ctrl"}, "V", function()
  hs.eventtap.keyStrokes(hs.pasteboard.getContents())
end)

---
-- Spectacle.app style window management
-- https://github.com/scottwhudson/Lunette
hs.loadSpoon("Lunette")
spoon.Lunette:bindHotkeys({
  leftHalf = {
    {{"cmd", "ctrl", "shift"}, "left"},
    {{"cmd", "ctrl", "shift"}, "H"},
  },
  rightHalf = {
    {{"cmd", "ctrl", "shift"}, "right"},
    {{"cmd", "ctrl", "shift"}, "L"},
  },
  topHalf = {
    {{"cmd", "ctrl", "shift"}, "up"},
    {{"cmd", "ctrl", "shift"}, "K"},
  },
  bottomHalf = {
    {{"cmd", "ctrl", "shift"}, "down"},
    {{"cmd", "ctrl", "shift"}, "J"},
  },
  topLeft = false,
  topRight = false,
  bottomLeft = false,
  bottomRight = false,
  fullScreen = false,
  center = false,
  nextThird = false,
  prevThird = false,
  enlarge = false,
  shrink = false,
  undo = {
    {{"cmd", "ctrl", "shift"}, "Z"},
  },
  redo = {
    {{"cmd", "ctrl", "shift"}, "Y"},
  },
  nextDisplay = false,
  prevDisplay = false,
})
