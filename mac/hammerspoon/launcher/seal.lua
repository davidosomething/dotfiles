---
-- App launcher
-- http://www.hammerspoon.org/Spoons/Seal.html
print "== launcher"

hs.loadSpoon("Seal")

spoon.Seal:loadPlugins({ "calc", "myapps" })
spoon.Seal:bindHotkeys({
  show = {{"cmd"}, "Space"}
})
spoon.Seal:start()

local seal = {
  name = "seal"
}
function seal.destructor()
  spoon.Seal:refreshAllCommands()
end
return seal
