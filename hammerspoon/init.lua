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
-- reload config
hs.hotkey.bind({"cmd", "ctrl", "shift"}, "R", function()
  hs.reload()
  hs.notify.new({title="Hammerspoon config reloaded", informativeText="Manually via keyboard shortcut"}):send()
end)

---
-- http://www.hammerspoon.org/Spoons/Caffeine.html
hs.loadSpoon("Caffeine")
spoon.Caffeine:bindHotkeys({
  toggle = {{"cmd", "ctrl", "shift"}, "C"},
})
spoon.Caffeine:start()

---
-- Spectacle.app style window management
-- https://github.com/scottwhudson/Lunette
hs.loadSpoon("Lunette")
spoon.Lunette:bindHotkeys({
  leftHalf = {
    {{"cmd", "ctrl", "shift"}, "H"},
  },
  rightHalf = {
    {{"cmd", "ctrl", "shift"}, "L"},
  },
  topHalf = {
    {{"cmd", "ctrl", "shift"}, "K"},
  },
  bottomHalf = {
    {{"cmd", "ctrl", "shift"}, "J"},
  },
  topLeft = false,
  topRight = false,
  bottomLeft = false,
  bottomRight = false,
  fullScreen = {
    {{"cmd", "ctrl", "shift"}, "F"},
  },
  center = false,
  nextThird = false,
  prevThird = false,
  enlarge = {
    {{"cmd", "ctrl", "shift"}, "up"},
  },
  shrink = {
    {{"cmd", "ctrl", "shift"}, "down"},
  },
  undo = {
    {{"cmd", "ctrl", "shift"}, "Z"},
  },
  redo = {
    {{"cmd", "ctrl", "shift"}, "Y"},
  },
  nextDisplay = false,
  prevDisplay = false,
})
