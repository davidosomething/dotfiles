---
-- clear seal cache and reload config
print "== reload"
hs.hotkey.bind(hyper, "R", function()
  spoon.Seal:refreshAllCommands()
  if audioWatcher then audioWatcher.stop() end
  if audiosourceBar then audiosourceBar:delete() end
  hs.notify.show("Reloading Hammerspoon config", "Manually", "")
  hs.reload()
end)

