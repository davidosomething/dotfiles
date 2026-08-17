---
-- http://www.hammerspoon.org/Spoons/Caffeine.html
print("== menubar.caffeine")

hs.loadSpoon("Caffeine")

spoon.Caffeine:start()

-- The Spoon calls hs.menubar.new() without an autosaveName, so macOS can't
-- persist its position. Name it here instead of patching the vendored Spoon.
spoon.Caffeine.menuBarItem:autosaveName("dko.caffeine")

return nil
