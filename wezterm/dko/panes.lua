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

--- Get panes that are on the same axis as the tab's active pane
---@param axis 'y'|'x'
---@param tab table
---@return table siblings
local function get_axis_siblings(axis, tab)
  local initial = tab:active_pane()
  local siblings = { initial }
  local prev_dir = axis == "x" and "Left" or "Up"
  local next_dir = axis == "x" and "Right" or "Down"

  local prev = tab:get_pane_direction(prev_dir)
  while prev do
    table.insert(siblings, 1, prev)
    prev:activate()
    prev = tab:get_pane_direction(prev_dir)
  end

  initial:activate() -- annoying
  local next = tab:get_pane_direction(next_dir)
  while next do
    table.insert(siblings, next)
    next:activate()
    next = tab:get_pane_direction(next_dir)
  end

  initial:activate() -- restore
  return siblings
end

--- Attempt to resize axis siblings to all the same size
---@param axis 'y'|'x'
M.balance = function(axis)
  ---@param win table
  return function(win)
    local tab = win:active_tab()
    local initial = tab:active_pane()
    local prev_dir = axis == "x" and "Left" or "Up"
    local next_dir = axis == "x" and "Right" or "Down"
    local siblings = get_axis_siblings(axis, tab)
    local tab_size = tab:get_size()[axis == "x" and "cols" or "rows"]
    local balanced_size = math.floor(tab_size / #siblings)
    local pane_size_key = axis == "x" and "cols" or "viewport_rows"
    wezterm.log_info(
      string.format(
        "resizing %s panes on %s axis to %s cells",
        #siblings,
        axis,
        balanced_size
      )
    )

    for i, p in ipairs(siblings) do
      local pane_size = p:get_dimensions()[pane_size_key]
      local adj_amount = pane_size - balanced_size
      local adj_dir = adj_amount < 0 and next_dir or prev_dir
      adj_amount = math.abs(adj_amount)
      wezterm.log_info(
        string.format(
          "adjusting pane %s from %s by %s cells %s",
          tostring(i),
          tostring(pane_size),
          tostring(adj_amount),
          adj_dir
        )
      )

      -- This does not work if you spawn a new term
      -- os.execute(
      --   string.format(
      --     "wezterm cli adjust-pane-size --pane-id %s --amount %s %s",
      --     tostring(p:pane_id()),
      --     tostring(adj_amount),
      --     adj_dir
      --   )
      -- )
      p:activate()
      win:perform_action(
        -- AdjustPaneSize only acts on active pane
        wezterm.action.AdjustPaneSize({ adj_dir, adj_amount }),
        p -- this does not affect anything
      )
    end

    -- restore initial since we had to activate each pane to resize it
    initial:activate()
  end
end

M.split_horz = scaled_split("Left")
M.split_vert = scaled_split("Up")

return M
