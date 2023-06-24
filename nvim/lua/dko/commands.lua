-- ===========================================================================
-- Commands
-- ===========================================================================

local command = vim.api.nvim_create_user_command

-- ===========================================================================
-- Command aliases
-- ===========================================================================

command("Q", "q", { bang = true, desc = ":Q same as :q" })

-- ===========================================================================
-- External interaction
-- ===========================================================================

-- This is a command run by ~/.dotfiles/bin/e before sending events to
-- existing server (e.g. --remote-send files to edit)
command("DKOExternal", function()
  require("dko.utils.close_floats")()

  local is_toggleterm = vim.api.nvim_buf_get_name(0):find("#toggleterm")
  if is_toggleterm then
    vim.cmd.close()
  end
end, { desc = "Prepare to receive an external command" })

command(
  "DKOLight",
  require("dko.colors").lightmode,
  { desc = "Set light colorscheme" }
)

command(
  "DKODark",
  require("dko.colors").darkmode,
  { desc = "Set dark colorscheme" }
)

-- ===========================================================================
-- File ops
-- ===========================================================================

command("Delete", function()
  local fp = vim.api.nvim_buf_get_name(0)

  local ok, err = vim.uv.fs_unlink(fp)
  if not ok then
    vim.notify(
      table.concat({ fp, err }, "\n"),
      vim.log.levels.ERROR,
      { title = ":Delete failed" }
    )
    vim.cmd.edit()
  else
    require("dko.utils.buffer").close()
    vim.notify(fp, vim.log.levels.INFO, { title = ":Delete succeeded" })
  end
end, { desc = "Delete current file" })

command("Rename", function(opts)
  local prev = vim.fn.expand("%:p")
  local prevname = vim.fn.expand("%:t")
  local prevdir = vim.fn.expand("%:p:h")
  vim.ui.input({
    prompt = "New file name: ",
    default = opts.fargs[1] or prevname,
    completion = "file",
  }, function(next)
    if not next or next == "" or next == prevname then
      return
    end

    local nextpath = ("%s/%s"):format(prevdir, next)
    vim.cmd.file(nextpath) -- rename buffer, preserving undo
    vim.cmd("noautocmd write") -- save
    vim.cmd("edit") -- update file syntax if you changed extension
    local ok, err = vim.uv.fs_unlink(prev)
    if not ok then
      vim.notify(
        table.concat({ prev, err }, "\n"),
        vim.log.levels.ERROR,
        { title = ":Rename failed to delete orig" }
      )
    end
  end)
end, {
  desc = "Rename current file",
  nargs = "?",
  complete = function()
    return { vim.fn.expand("%") }
  end,
})
