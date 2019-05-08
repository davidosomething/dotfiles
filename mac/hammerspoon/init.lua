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
-- Display audiosource
-- setAudiosourceBarTitle(uid, event_name, event_scope, event_element)
local audiosourceBar = hs.menubar.new()
local function nextAudiosource (mods)
  local result = hs.execute('/usr/local/bin/SwitchAudioSource -n')
end
audiosourceBar:setClickCallback(nextAudiosource)
local function setAudiosourceBarTitle (e)
  if e ~= 'dOut' then return end
  local defaultDevice = hs.audiodevice.defaultOutputDevice()
  local title = defaultDevice:name()
  if title == 'Built-in Output' then title = 'H'
  elseif title == 'Built-in Line Output' then title = 'L'
  elseif title == 'Built-in Digital Output' then title = 'D'
  end
  audiosourceBar:setTitle(title)
end
setAudiosourceBarTitle('dOut')
local audioWatcher = hs.audiodevice.watcher
audioWatcher.setCallback(setAudiosourceBarTitle)
audioWatcher.start()

---
-- clear seal cache and reload config
hs.hotkey.bind(hyper, "R", function()
  spoon.Seal:refreshAllCommands()
  if audioWatcher then audioWatcher.stop() end
  if audiosourceBar then audiosourceBar:delete() end
  hs.notify.show("Reloading Hammerspoon config", "Manually", "")
  hs.reload()
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
