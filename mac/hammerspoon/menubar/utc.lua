---
-- Display current UTC time
print("== menubar.utc")

-- autosaveName lets macOS persist this item's position in the menubar
local utcBar = hs.menubar.new(true, "dko.utc")

-- Copy a full ISO-8601 UTC timestamp on click
local function copyUtcTimestamp()
  local stamp = os.date("!%Y-%m-%dT%H:%M:%SZ")
  hs.pasteboard.setContents(stamp)
  hs.notify.show("Copied UTC timestamp", stamp, "")
end
utcBar:setClickCallback(copyUtcTimestamp)

local lastTitle = nil
local function setUtcBarTitle()
  local title = os.date("!%H:%M") .. "Z"
  if title ~= lastTitle then
    lastTitle = title
    utcBar:setTitle(title)
  end
end
setUtcBarTitle()

local utcTimer = hs.timer.doEvery(1, setUtcBarTitle)

local M = {
  name = "utc",
  destructor = function()
    utcTimer:stop()
    utcBar:delete()
  end,
}
return M
