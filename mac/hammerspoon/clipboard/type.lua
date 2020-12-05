---
-- type what is in the clipboard
print "== clipboard.type"

hs.hotkey.bind({"cmd", "ctrl"}, "V", function()
  hs.eventtap.keyStrokes(hs.pasteboard.getContents())
end)

return nil
