--
-- Spectacle.app style window management
-- https://github.com/scottwhudson/Lunette
print("== window.lunette")

hs.loadSpoon("Lunette")

spoon.Lunette:bindHotkeys({
  cycleWidth = false,
  leftHalf = { { mc, "A" } },
  -- skhd forwards cmd-ctrl-d here so it isn't swallowed by the macOS Dictionary
  -- lookup; `hyper` is cmd-ctrl-shift (see init.lua)
  rightHalf = { { hyper, "D" } },
  topHalf = { { mc, "K" } },
  bottomHalf = { { mc, "J" } },
  topLeft = { { mc, "Q" } },
  topRight = { { mc, "E" } },
  bottomLeft = { { mc, "Z" } },
  bottomRight = { { mc, "C" } },
  fullScreen = { { mc, "F" } },
  center = { { mc, "S" } },
  nextThird = false,
  prevThird = false,
  enlarge = false,
  shrink = false,
})

return nil
