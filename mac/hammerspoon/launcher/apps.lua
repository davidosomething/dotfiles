---
-- Generic app keybinds

print("== launcher.apps")

hs.hotkey.bind(hyper, "b", function()
  hs.application.launchOrFocus("Bitwarden")
end)

hs.hotkey.bind(hyper, "g", function()
  hs.application.launchOrFocus("Google Chrome")
end)

-- m for menubarx https://menubarx.app/

hs.hotkey.bind(hyper, "n", function()
  hs.application.launchOrFocus("Standard Notes")
end)

hs.hotkey.bind(hyper, "s", function()
  hs.application.launchOrFocus("Slack")
end)

hs.hotkey.bind(hyper, "t", function()
  hs.application.launchOrFocus("WezTerm")
end)

hs.hotkey.bind(hyper, ",", function()
  local url =
    "x-apple.systempreferences:com.apple.Software-Update-Settings.extension"
  local scheme = url:match("^([^:]+)")
  local handler = hs.urlevent.getDefaultHandler(scheme)
  hs.urlevent.openURLWithBundle(url, handler)
end)
