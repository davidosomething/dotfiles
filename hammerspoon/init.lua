-- ---------------------------------------------------------------------------
-- init.lua
-- ---------------------------------------------------------------------------

-- luacheck: globals hs spoon

hyper = {"⌘", "⌃", "⇧"}

---
-- type what is in the clipboard
hs.hotkey.bind({"cmd", "ctrl"}, "V", function()
  hs.eventtap.keyStrokes(hs.pasteboard.getContents())
end)

---
-- reload config
hs.hotkey.bind(hyper, "R", function()
  hs.reload()
  hs.notify.new({title="Hammerspoon config reloaded", informativeText="Manually via keyboard shortcut"}):send()
end)

---
-- http://www.hammerspoon.org/Spoons/Caffeine.html
hs.loadSpoon("Caffeine")
spoon.Caffeine:bindHotkeys({
  toggle = {hyper, "C"},
})
spoon.Caffeine:start()

---
-- App launcher
-- http://www.hammerspoon.org/Spoons/Seal.html
hs.loadSpoon("Seal")
spoon.Seal:loadPlugins({ "calc", "myapps" })
spoon.Seal:bindHotkeys({
  show = {hyper, "Space"}
})
spoon.Seal:start()

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
