local M = {}

-- Generate a line of pattern pat end of line to &textwidth
---@param pat string
M.fill = function(pat)
  local patlen = pat:len()
  local lastcol = vim.fn.col("$")
  -- how many characters left from end of line to textwidth
  local available = math.max(vim.bo.textwidth - (lastcol - 2), 0)
  -- how many repititions of pat can we append before hitting &textwidth
  local reps = math.floor(available / patlen) - 1
  if reps < 1 then
    return
  end

  -- Insert a space if the line is dirty and doesn't already end with
  -- whitespace
  local last_char = (vim.api.nvim_get_current_line()):sub(-1)
  local is_end_space = last_char == " " or last_char == "\t"
  if lastcol > 1 and not is_end_space then
    vim.cmd("normal! 1A ")
    reps = math.floor((available - 1) / patlen) - 1
    if reps < 1 then
      return
    end
  end

  -- Insert the rule, go to next line
  vim.cmd("normal! " .. reps .. "A" .. pat)
  vim.api.nvim_feedkeys("o", "nt", true)
end

return M
