---
-- Generic app keybinds

print "== launcher.apps"

-- a is for lunette left

hs.hotkey.bind(hyper, 'b', function()
  hs.application.launchOrFocus("Bitwarden")
end)

-- C is for caffeine

-- d is for lunette right

-- f for lunette

hs.hotkey.bind(hyper, 'g', function()
  hs.application.launchOrFocus("Google Chrome")
end)

-- h for lunette

hs.hotkey.bind(hyper, 'n', function()
  hs.application.launchOrFocus("Standard Notes")
end)

hs.hotkey.bind(hyper, 's', function()
  hs.application.launchOrFocus("Slack")
end)

hs.hotkey.bind(hyper, ',', function()
  local url = 'x-apple.systempreferences:com.apple.Software-Update-Settings.extension'
  local scheme = url:match('^([^:]+)')
  local handler = hs.urlevent.getDefaultHandler(scheme)
  hs.urlevent.openURLWithBundle(url, handler)
end)
