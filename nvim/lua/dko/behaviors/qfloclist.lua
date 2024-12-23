local augroup = require("dko.utils.autocmd").augroup
local autocmd = vim.api.nvim_create_autocmd

-- @TODO keep an eye on https://github.com/neovim/neovim/issues/23581
autocmd("WinLeave", {
  desc = "Toggle close->open loclist so it is always under the correct window",
  callback = function()
    if vim.bo.buftype == "quickfix" then
      -- Was in loclist already
      return
    end
    local loclist_winid = vim.fn.getloclist(0, { winid = 0 }).winid
    if loclist_winid == 0 then
      return
    end

    local leaving = vim.api.nvim_get_current_win()
    autocmd("WinEnter", {
      callback = function()
        if vim.bo.buftype == "quickfix" then
          -- Left main window and went into the loclist
          return
        end
        local entering = vim.api.nvim_get_current_win()
        vim.o.eventignore = "all"
        vim.api.nvim_set_current_win(leaving)
        vim.cmd.lclose()
        vim.cmd.lwindow()
        vim.api.nvim_set_current_win(entering)
        vim.o.eventignore = ""
      end,
      once = true,
    })
  end,
  group = augroup("dkowindow"),
})

autocmd("QuitPre", {
  desc = "Auto close corresponding loclist when quitting a window",
  callback = function()
    if vim.bo.filetype ~= "qf" then
      vim.cmd("silent! lclose")
    end
  end,
  nested = true,
  group = augroup("dkowindow"),
})
