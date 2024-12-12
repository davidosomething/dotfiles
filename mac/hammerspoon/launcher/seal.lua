---
-- App launcher
-- http://www.hammerspoon.org/Spoons/Seal.html
print("== launcher")

hs.loadSpoon("Seal")

spoon.Seal:loadPlugins({ "calc", "myapps", "useractions" })

spoon.Seal:bindHotkeys({
  show = { { "cmd" }, "Space" },
})

spoon.Seal.plugins.useractions.actions = {
  ["restart"] = {
    fn = function()
      hs.caffeinate.restartSystem()
    end,
  },
  ["shutdown"] = {
    fn = function()
      hs.caffeinate.shutdownSystem()
    end,
  },
}

spoon.Seal:start()

local seal = {
  name = "seal",
}
function seal.destructor()
  spoon.Seal:refreshAllCommands()
end
return seal
