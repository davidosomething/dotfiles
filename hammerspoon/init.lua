-- ---------------------------------------------------------------------------
-- init.lua
-- ---------------------------------------------------------------------------

print("======================================================================")

hyper = {"⌘", "⌃", "⇧"}

---
-- type what is in the clipboard
hs.hotkey.bind({"cmd", "ctrl"}, "V", function()
  hs.eventtap.keyStrokes(hs.pasteboard.getContents())
end)

---
-- clear seal cache and reload config
hs.hotkey.bind(hyper, "R", function()
  spoon.Seal:refreshAllCommands()
  hs.reload()
  hs.notify.show("Hammerspoon config reloaded", "Manually", "")
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
spoon.Seal:refreshAllCommands()
spoon.Seal:bindHotkeys({
  show = {{"cmd"}, "Space"}
})
spoon.Seal:start()

---
-- Big stuff
require("window")
