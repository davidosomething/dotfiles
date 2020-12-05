---
-- Generic app keybinds

print "== launcher.apps"

hs.hotkey.bind(hyper, 'a', function()
  hs.application.launchOrFocus("Authy Desktop")
end)

hs.hotkey.bind(hyper, 'b', function()
  hs.application.launchOrFocus("Bitwarden")
end)

-- C is for caffeine

hs.hotkey.bind(hyper, 'd', function()
  hs.application.launchOrFocus("Discord")
end)

-- f for lunette

hs.hotkey.bind(hyper, 'g', function()
  hs.application.launchOrFocus("Google Chrome")
end)

-- h for lunette

hs.hotkey.bind(hyper, 'i', function()
  hs.application.launchOrFocus("iTerm")
end)

-- jkl for lunette

hs.hotkey.bind(hyper, 'n', function()
  hs.application.launchOrFocus("Joplin")
end)

hs.hotkey.bind(hyper, 's', function()
  hs.application.launchOrFocus("Slack")
end)

return nil
