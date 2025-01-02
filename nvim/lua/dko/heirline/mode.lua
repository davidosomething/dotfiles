local utils = require("heirline.utils")

-- Now we define some dictionaries to map the output of mode() to the
-- corresponding string and color. We can put these into `static` to compute
-- them at initialisation time.
local mode_names = { -- change the strings if you like it vvvvverbose!
  n = "N",
  no = "N",
  nov = "N",
  noV = "N",
  ["no\22"] = "N",
  niI = "N",
  niR = "N",
  niV = "N",
  nt = "N",
  v = "V",
  vs = "V",
  V = "V",
  Vs = "V",
  ["\22"] = "V",
  ["\22s"] = "V",
  s = "S",
  S = "S",
  ["\19"] = "S",
  i = "I",
  ic = "I",
  ix = "I",
  R = "R",
  Rc = "R",
  Rx = "R",
  Rv = "R",
  Rvc = "R",
  Rvx = "R",
  c = "C",
  cv = "E",
  r = ".",
  rm = "M",
  ["r?"] = "?",
  ["!"] = "!",
  t = "T",
}

local mode_colors = {
  n = "red",
  i = "green",
  v = "cyan",
  ["\22"] = "cyan",
  c = "orange",
  s = "purple",
  ["\19"] = "purple",
  r = "orange",
  ["!"] = "red",
  t = "red",
}

local function mode_hl()
  local mode = vim.fn.mode(1):sub(1, 1):lower() -- get only the first mode character

  -- My hardcoded settings
  if mode == "n" then
    return "StatusLine"
  elseif mode == "c" then
    return "DiffDelete"
  elseif mode == "i" then
    return "dkoStatusItem"
  elseif mode == "r" then
    return "dkoLineModeReplace"
  elseif mode == "v" then
    return "Cursor"
  end

  return { fg = mode_colors[mode] }
end

return {
  -- get vim current mode, this information will be required by the provider
  -- and the highlight functions, so we compute it only once per component
  -- evaluation and store it as a component attribute
  init = function(self)
    self.mode = vim.fn.mode(1) -- :h mode()

    -- execute this only once, this is required if you want the ViMode
    -- component to be updated on operator pending mode
    if not self.once then
      vim.api.nvim_create_autocmd("ModeChanged", {
        pattern = "*:*o",
        command = "redrawstatus",
      })
      self.once = true
    end
  end,

  utils.surround({ "█", "" }, function()
    local hl = mode_hl()
    if type(hl) == "string" then
      return utils.get_highlight(hl).bg
    end
    return utils.get_highlight("StatusLine").bg
  end, {
    provider = function(self)
      return mode_names[self.mode]
    end,

    -- Same goes for the highlight. Now the foreground will change according to the current mode.
    hl = function()
      return mode_hl()
    end,

    -- Re-evaluate the component only on ModeChanged event!
    -- This is not required in any way, but it's there, and it's a small
    -- performance improvement.
    update = { "ModeChanged", "TermLeave" },
  }),
}
