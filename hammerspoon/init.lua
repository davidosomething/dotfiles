-- ---------------------------------------------------------------------------
-- init.lua
-- ---------------------------------------------------------------------------

---
-- cmd-alt-v to type what is in the clipboard
hs.hotkey.bind({"cmd", "alt", "shift"}, "V", function()
  hs.eventtap.keyStrokes(hs.pasteboard.getContents())
end)
