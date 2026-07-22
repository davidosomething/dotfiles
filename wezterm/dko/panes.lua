local wezterm = require("wezterm")

local M = {}

-- Change split behavior
-- If this is a middle split, default behavior
--    - you can use this to do regular half splits by jumping into prev window
--      and split from there
-- If there is no split in that direction split is halved
-- If there's an existing split in that direction then
--    split prev,curr,new evenly into thirds
--
---@param dir "Left"|"Up"
local scaled_split = function(dir)
  return function(win, pane)
    --wezterm.log_info("split " .. dir)
    local tab = win:active_tab()

    local opposite = dir == "Left" and "Right" or "Down"
    local next = tab:get_pane_direction(opposite)
    if not next then
      local size_key = dir == "Left" and "cols" or "viewport_rows"
      local prev = tab:get_pane_direction(dir)
      if prev then
        -- first resize the prev pane to be 1/3 vs 2/6
        -- then split this pane
        local prev_width = prev:get_dimensions()[size_key]
        local self_width = pane:get_dimensions()[size_key]
        local total_width = prev_width + self_width
        local onethird = math.floor(total_width / 3)

        -- if 1/3 is 26cols, and prev is 30 cols, we want to
        -- - grow pane by 4, i.e. shrink prev by 4
        local difference = prev_width < onethird and 0 or prev_width - onethird
        --wezterm.log_info(string.format('%s %s %s', onethird, prev_width, self_width))
        win:perform_action(
          wezterm.action.AdjustPaneSize({ dir, difference }),
          pane
        )
      end
    end

    pane:split({ direction = dir == "Left" and "Right" or "Bottom" })
  end
end

M.split_horz = scaled_split("Left")
M.split_vert = scaled_split("Up")

M.setup = function()
  local home = os.getenv("HOME") or ""
  local unicode_block = "⠀"

  wezterm.on("update-right-status", function(win, pane)
    local cwd_uri = pane:get_current_working_dir()
    local cwd = ""
    if cwd_uri then
      cwd = (cwd_uri.file_path or tostring(cwd_uri)):gsub("^" .. home, "~")
    end
    win:set_right_status(("%s%s%s"):format(unicode_block, cwd, unicode_block))
  end)
end

return M
