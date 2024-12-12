--- My fork of seal_apps.lua
--- See https://github.com/Hammerspoon/Spoons/blob/master/Source/Seal.spoon/seal_apps.lua
--- A plugin to add launchable apps/scripts, making Seal act as a launch bar

local M = {}
M.__index = M
M.__name = "seal_myapps"

---@alias DisplayName string

---@type table<DisplayName, table>
M.results_cache = {}

local QUERY_STRING = [[
  (kMDItemContentType = "com.apple.application-bundle") ||
  (kMDItemContentType = "com.apple.systempreference.prefpane") ||
  (kMDItemContentType = "com.apple.applescript.text") ||
  (kMDItemContentType = "com.apple.applescript.script")
]]

local SEARCH_PATHS = {
  "/Applications",
  "/System/Applications",
  "~/Applications",
  "/Applications/Xcode.app/Contents/Applications",
  "/Applications/Xcode.app/Contents/Developer/Applications",
  "/System/Library/PreferencePanes",
  "/Library/PreferencePanes",
  "~/Library/PreferencePanes",
  "/System/Library/CoreServices/Applications",
  "/System/Library/CoreServices", -- finder.app is here
  "/usr/local/Cellar",
}

---Namespace for functions related to item processing
local Item = {}

Item.is_pref_pane = function(item)
  return item.kMDItemPath ~= nil
    and item.kMDItemPath
    and string.find(item.kMDItemPath, "%.prefPane$")
end

---@param item any
---@return DisplayName|nil
Item.get_display_name = function(item)
  if item == nil then
    return nil
  end

  local display_name = item.kMDItemDisplayName
  if display_name == nil and item.kMDItemPath then
    display_name = hs.fs.display_name(item.kMDItemPath)
  end
  if not display_name or display_name == "" then
    return nil
  end

  display_name = display_name:gsub("%.app$", "", 1)

  local is_pref_pane_item = Item.is_pref_pane(item)
  return ("%s%s"):format(
    display_name,
    is_pref_pane_item and " preferences" or ""
  )
end

Item.get_icon = function(item)
  local is_pref_pane_item = Item.is_pref_pane(item)
  if is_pref_pane_item then
    return hs.image.iconForFile(item.kMDItemPath)
  end

  local bundleID = item.kMDItemCFBundleIdentifier
  if bundleID then
    return hs.image.imageFromAppBundle(bundleID)
  end

  return nil
end

---Namespace for functions related to results cache management
local Cache = {}

---@param item table
Cache.add = function(item)
  local display_name = Item.get_display_name(item)
  if display_name then
    M.results_cache[display_name] = {
      path = item.kMDItemPath,
      bundleID = item.kMDItemCFBundleIdentifier,
      icon = Item.get_icon(item),
    }
  end
end

---@param item table
Cache.remove = function(item)
  local display_name = Item.get_display_name(item)
  if display_name then
    M.results_cache[display_name] = nil
  end
end

---Update cache
---@param spotlight_results table spotlight results
---@param add? boolean upsert to cache or remove?
Cache.update = function(spotlight_results, add)
  for _, item in ipairs(spotlight_results) do
    if item then
      if add then
        Cache.add(item)
      else
        Cache.remove(item)
      end
    end
  end
end

local Choices = {}

---@param query string
---@param filter? fun(obj): boolean
---@return table -- results_cache mapped to choices filtered by string match
Choices.get = function(query, filter)
  if not query or query == "" then
    return {}
  end

  local results = {}
  for name, app in pairs(M.results_cache) do
    if string.match(name:lower(), query:lower()) then
      local choice = {}

      local running = app["bundleID"] ~= nil
        and app["bundleID"] ~= ""
        and #hs.application.applicationsForBundleID(app["bundleID"]) > 0

      choice["text"] = ("%s%s"):format(name, running and " (Running)" or "")
      choice["subText"] = app["path"]
      choice["image"] = app["icon"]
      choice["path"] = app["path"]
      choice["uuid"] = ("%s__%s"):format(M.__name, app["bundleID"] or name)
      choice["plugin"] = M.__name

      local should_insert = filter == nil or filter({ running = running })
      if should_insert then
        table.insert(results, choice)
      end
    end
  end
  return results
end

---@param params { running: boolean }
---@return boolean
Choices.filter_revealable = function(params)
  return params.running
end

---@param query string
---@return table where results have a type of "reveal"
Choices.get_revealable = function(query)
  local results = Choices.get(query, Choices.filter_revealable)
  for _, result in pairs(results) do
    result["type"] = "reveal"
  end
  return results
end

---@param query string
---@return table
Choices.get_killable = function(query)
  if not query or query == "" then
    return {}
  end

  local results = {}
  local apps = hs.application.runningApplications()
  for _, app in pairs(apps) do
    local name = app:name()
    if string.match(name:lower(), query:lower()) and app:mainWindow() then
      local choice = {}
      choice["text"] = "Kill " .. name
      choice["subText"] = app:path() .. " PID: " .. app:pid()
      choice["pid"] = app:pid()
      choice["plugin"] = M.__name
      choice["type"] = "kill"
      choice["image"] = hs.image.imageFromAppBundle(app:bundleID())
      table.insert(results, choice)
    end
  end
  return results
end

---Callback for https://www.hammerspoon.org/docs/hs.spotlight.html#setCallback
---@param _ table spotlight_instance
---@param msg "didStart"|"inProgress"|"didFinish"|"didUpdate"
---@param spotlight_results table list of spotlight items
local function spotlight_results_callback(_, msg, spotlight_results)
  if not spotlight_results then
    -- shouldn't happen for didUpdate or inProgress
    print("~~~ userInfo from SpotLight was empty for " .. msg)
    return
  end

  -- all three can occur in either message, so check them all!
  if spotlight_results.kMDQueryUpdateAddedItems then
    Cache.update(spotlight_results.kMDQueryUpdateAddedItems, true)
  end
  if spotlight_results.kMDQueryUpdateChangedItems then
    Cache.update(spotlight_results.kMDQueryUpdateChangedItems, true)
  end
  if spotlight_results.kMDQueryUpdateRemovedItems then
    Cache.update(spotlight_results.kMDQueryUpdateRemovedItems, false)
  end
end

--- ============================================================================
--- Seal plugin implementation
--- ============================================================================

--- Seal.plugins.myapps:start()
--- This is called automatically when the plugin is loaded
function M:start()
  self.spotlight = hs.spotlight
    .new()
    :queryString(QUERY_STRING)
    :callbackMessages("didUpdate", "inProgress")
    :setCallback(spotlight_results_callback)
    :searchScopes(SEARCH_PATHS)
    :start()
end

function M:stop()
  self.spotlight:stop()
  self.spotlight = nil
  self.results_cache = {}
end

function M:restart()
  self:stop()
  self:start()
end

---Implements Spoons/Seal.spoon plugin:bare()
function M:bare()
  return Choices.get
end

---Implements Spoons/Seal.spoon plugin:commands()
function M:commands()
  return {
    kill = {
      cmd = "kill",
      description = "Kill an application",
      fn = Choices.get_killable,
      name = "Kill",
      plugin = M.__name,
    },
    reveal = {
      cmd = "reveal",
      description = "Reveal an application in the Finder",
      fn = Choices.get_revealable,
      name = "Reveal",
      plugin = M.__name,
    },
  }
end

---Implements Spoons/Seal.spoon plugin.completionCallback
M.completionCallback = function(choice)
  if not choice["type"] then
    if
      string.find(choice["path"], "%.applescript$")
      or string.find(choice["path"], "%.scpt$")
    then
      hs.task.new("/usr/bin/osascript", nil, { choice["path"] }):start()
      return
    end
    hs.task.new("/usr/bin/open", nil, { choice["path"] }):start()
    return
  end

  if choice["type"] == "kill" then
    hs.application.get(choice["pid"]):kill()
    return
  end

  if choice["type"] == "reveal" then
    hs.osascript.applescript(
      string.format(
        [[tell application "Finder" to reveal (POSIX file "%s")]],
        choice["path"]
      )
    )
    hs.application.launchOrFocus("Finder")
  end
end

-- ===========================================================================
-- Immediate
-- ===========================================================================

hs.application.enableSpotlightForNameSearches(true)
M:start()

return M
