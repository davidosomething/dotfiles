---
-- Display audiosource
-- setAudiosourceBarTitle(uid, event_name, event_scope, event_element)
print("== menubar.audiosource")

local audiosourceBar = hs.menubar.new()

local function nextAudiosource()
  local _, status = hs.execute("/opt/homebrew/bin/SwitchAudioSource -n")
  if not status then
    hs.notify.show(
      "Failed to SwitchAudioSource",
      "Is SwitchAudioSource installed?"
    )
  end
end
audiosourceBar:setClickCallback(nextAudiosource)

local function setAudiosourceBarTitle(e)
  if e ~= "dOut" then
    return
  end
  local defaultDevice = hs.audiodevice.defaultOutputDevice()
  local title = defaultDevice:name()
  if title == "Built-in Output" then
    title = "H"
  elseif title == "Built-in Line Output" then
    title = "L"
  elseif title == "Built-in Digital Output" then
    title = "D"
  end
  audiosourceBar:setTitle(title)
end
setAudiosourceBarTitle("dOut")

hs.audiodevice.watcher.setCallback(setAudiosourceBarTitle)
hs.audiodevice.watcher.start()

local M = {
  name = "audiosource",
  destructor = function()
    hs.audiodevice.watcher.stop()
    audiosourceBar:delete()
  end,
}
return M
