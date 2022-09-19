---
-- Display audiosource
-- setAudiosourceBarTitle(uid, event_name, event_scope, event_element)
print "== menubar.audiosource"

local audiosourceBar = hs.menubar.new()

local function nextAudiosource()
  hs.execute("/opt/homebrew/bin/SwitchAudioSource -n")
end

local function setAudiosourceBarTitle(e)
  if e ~= "dOut" then return end
  local defaultDevice = hs.audiodevice.defaultOutputDevice()
  local title = defaultDevice:name()
  if title == "Built-in Output" then title = "H"
  elseif title == "Built-in Line Output" then title = "L"
  elseif title == "Built-in Digital Output" then title = "D"
  end
  audiosourceBar:setTitle(title)
end

audiosourceBar:setClickCallback(nextAudiosource)

setAudiosourceBarTitle("dOut")

local audioWatcher = hs.audiodevice.watcher
audioWatcher.setCallback(setAudiosourceBarTitle)
audioWatcher.start()

local audiosource = {
  name = "audiosource"
}
function audiosource.destructor()
  audioWatcher.stop()
  audiosourceBar:delete()
end
return audiosource
