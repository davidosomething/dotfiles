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
