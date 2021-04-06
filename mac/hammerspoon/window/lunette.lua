---
-- Spectacle.app style window management
-- https://github.com/scottwhudson/Lunette
print "== window.lunette"

hs.loadSpoon("Lunette")

spoon.Lunette:bindHotkeys({
  cycleWidth = {
    {hyper, "W"},
  },
  leftHalf = {
    {hyper, "A"},
  },
  rightHalf = {
    {hyper, "D"},
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
})

return nil
