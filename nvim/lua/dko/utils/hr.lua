local M = {}

-- Generate a line of pattern pat end of line to &textwidth
---@param pat string
M.fill = function(pat)
  ---@TODO make this an arg?
  local opts = { right_padding = 2 }

  local target_col = vim.bo.textwidth - opts.right_padding
  if target_col <= 0 then
    -- bad right_padding
    return
  end

  local current_line = vim.api.nvim_get_current_line()

  local filled_line = current_line
  local last_char = filled_line:sub(-1)
  local is_empty = filled_line == ""
  local is_end_space = last_char == " " or last_char == "\t"
  if not is_empty and not is_end_space then
    filled_line = filled_line .. " "
  end
  while filled_line:len() + pat:len() <= target_col do
    filled_line = filled_line .. pat
  end
  if current_line == filled_line then
    -- no change, no-op
    return
  end

  -- apply change
  vim.api.nvim_set_current_line(filled_line)
  -- go to the next line
  vim.api.nvim_feedkeys("o", "nt", true)
end

return M
