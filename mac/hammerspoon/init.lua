-- ---------------------------------------------------------------------------
-- init.lua
-- ---------------------------------------------------------------------------

print("======================================================================")

hs.autoLaunch(true)
hs.consoleOnTop(false)
hs.dockIcon(false)
hs.menuIcon(true)

hyper = {"⌘", "⌃", "⇧"}

local mods = {}
table.insert(mods, require("clipboard.type"))
table.insert(mods, require("menubar.audiosource"))
table.insert(mods, require("menubar.caffeine"))
table.insert(mods, require("launcher.apps"))
table.insert(mods, require("launcher.seal"))
table.insert(mods, require("window.lunette"))
table.insert(mods, require("window.throw"))

print "== reload"
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
