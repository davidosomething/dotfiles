-- ---------------------------------------------------------------------------
-- init.lua
-- ---------------------------------------------------------------------------

print("======================================================================")

hs.autoLaunch(true)
hs.consoleOnTop(false)
hs.dockIcon(false)
hs.menuIcon(true)

_G.mc = { "⌘", "⌃" }
_G.hyper = { "⌘", "⌃", "⇧" }

-- Generate LuaCATS/EmmyLua annotations for the installed hs.* API and Spoons
-- into Spoons/EmmyLua.spoon/annotations (wired into .luarc.json's
-- workspace.library). Loaded first, before any mod sets up a pathwatcher, per
-- the Spoon's own guidance.
hs.loadSpoon("EmmyLua")

local mods = {}
mods[#mods + 1] = require("clipboard.type")
mods[#mods + 1] = require("menubar.audiosource")
mods[#mods + 1] = require("menubar.caffeine")
mods[#mods + 1] = require("launcher.apps")
mods[#mods + 1] = require("launcher.seal")
mods[#mods + 1] = require("window.lunette")
mods[#mods + 1] = require("window.throw")

print("== reload")
hs.hotkey.bind(hyper, "R", function()
  for _, mod in ipairs(mods) do
    if type(mod) == "table" and mod["destructor"] then
      print("== destroying " .. mod["name"])
      mod["destructor"]()
    end
  end
  hs.notify.show("Reloading Hammerspoon config", "Manually", "")
  print("reloading...")
  hs.reload()
end)
