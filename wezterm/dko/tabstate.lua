local wezterm = require("wezterm")

local notifier = require("dko/notifier")

--- Tab state

local xdg_state_home = os.getenv("XDG_STATE_HOME")
  or os.getenv("HOME") .. "/.local/state"

---Other applications READ this file. One `<pane_id> <tab_id>` pair per line,
---e.g. `53 19` -- it resolves $WEZTERM_PANE to the tab that owns it without
---paying for a `wezterm cli list` round trip, see bin/wez-tab-id.
---
---Every live tab owns at least one pane, so the second column doubles as the
---list of tabs that still exist, see bin/wez-clean-socks.
local tab_state_file = ("%s/wezterm-tab-state.txt"):format(xdg_state_home)

---Written here first and renamed over tab_state_file, so a reader can never
---catch the file mid-write
local tab_state_tempfile = ("%s.tmp"):format(tab_state_file)

local M = {}

---Contents as of the last successful write, to skip rewriting an unchanged
---file on every tick
---@type string|nil
local last_contents = nil

---This runs on an interval, so only notify on the first failure of a streak
local notified = false

---@return string -- e.g. "53 19\n54 19\n55 20\n", "" when the mux is empty
local get_contents = function()
  local lines = {}
  for _, window in ipairs(wezterm.mux.all_windows()) do
    for _, tab in ipairs(window:tabs()) do
      local tab_id = tab:tab_id()
      for _, pane in ipairs(tab:panes()) do
        table.insert(lines, ("%d %d\n"):format(pane:pane_id(), tab_id))
      end
    end
  end
  -- stable order, so merely reordering tabs doesn't count as a change
  table.sort(lines)
  return table.concat(lines)
end

---Sync tab_state_file with the current state of the mux
M.write = function()
  local contents = get_contents()
  if contents == last_contents then
    return
  end

  local file_handle, err = io.open(tab_state_tempfile, "w")
  if file_handle then
    file_handle:write(contents)
    file_handle:close()

    local renamed, rename_err = os.rename(tab_state_tempfile, tab_state_file)
    if renamed then
      last_contents = contents
      notified = false
      return
    end
    err = rename_err
  end

  if not notified then
    notified = true
    notifier.os(
      ("Could not update %s: %s"):format(
        tab_state_file,
        err or "Reason unknown"
      )
    )
  end
end

M.setup = function()
  -- Fires per window on config.status_update_interval (default 1s), so a pane
  -- moved to another tab corrects itself within a tick
  wezterm.on("update-status", M.write)

  -- Tab ids restart at 0 with a new mux, so clear out the previous run's map
  -- before any of those ids get reused
  wezterm.on("mux-startup", M.write)
end

return M
