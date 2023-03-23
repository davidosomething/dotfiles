---
-- Generic app keybinds

print "== launcher.apps"

-- a is for lunette left

hs.hotkey.bind(hyper, 'b', function()
  hs.application.launchOrFocus("Bitwarden")
end)

-- C is for caffeine
--
-- d is for lunette right

-- f for lunette

hs.hotkey.bind(hyper, 'g', function()
  hs.application.launchOrFocus("Google Chrome")
end)

-- h for lunette

hs.hotkey.bind(hyper, 'n', function()
  hs.application.launchOrFocus("Joplin")
end)

hs.hotkey.bind(hyper, 's', function()
  hs.application.launchOrFocus("Slack")
end)

return nil
