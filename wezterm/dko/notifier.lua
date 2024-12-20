local wezterm = require("wezterm")

local notifier = "osascript -e 'display notification"
local close = "'"
if string.find(wezterm.target_triple, "linux") then
  notifier = "notify-send --app-name=WezTerm --urgency=low --expire-time=500"
  close = ""
end

local M = {}

---Send an OS notification
---@param message string
M.os = function(message)
  local command = ('%s "%s" %s'):format(notifier, message, close)
  os.execute(command)
end

local toast_command = [[printf "\e]9;%s\e\\"]]

---Toast using wezterm window:toast_notification
---Don't use... doesn't work from nvim job, mux, ssh, etc.
---and subject to OS notification settings for the app - e.g. on mac
---https://github.com/wez/wezterm/issues/5476
---@param message string
M.toast = function(message)
  local command = ('%s "%s"'):format(toast_command, message)
  os.execute(command)
end

return M
