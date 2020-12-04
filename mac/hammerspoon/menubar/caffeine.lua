---
-- http://www.hammerspoon.org/Spoons/Caffeine.html
print "== menubar.caffeine"
hs.loadSpoon("Caffeine")
spoon.Caffeine:bindHotkeys({
  toggle = {hyper, "C"},
})
spoon.Caffeine:start()
