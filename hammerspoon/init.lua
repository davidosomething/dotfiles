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
-- reload config
hs.hotkey.bind(hyper, "R", function()
  hs.reload()
  hs.notify.new({
    title="Hammerspoon config reloaded",
    informativeText="Manually via keyboard shortcut",
  }):send()
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
  show = {{"cmd"}, "Space"}
})
spoon.Seal:start()

---
-- Big stuff
require("window")
