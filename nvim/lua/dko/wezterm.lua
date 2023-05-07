local colorscheme_file_path = os.getenv('XDG_STATE_HOME') .. '/wezterm-colorscheme.txt'

local M = {}

local colorscheme_handle = nil
M.monitor_colorscheme = function ()
  if colorscheme_handle ~= nil then
    return colorscheme_handle
  end

  colorscheme_handle = vim.loop.new_fs_event()
  if not colorscheme_handle then
    return nil
  end

  vim.loop.fs_event_start(
    colorscheme_handle,
    colorscheme_file_path,
    {},
    M.apply_darkmode_setting
  )

  return colorscheme_handle
end

M.apply_darkmode_setting = function ()
  vim.loop.fs_open(colorscheme_file_path, "r", 438, function(_, fd)
    if fd == nil then return end
    vim.loop.fs_fstat(fd, function(_, stat)
      if stat ==nil then return end
      vim.loop.fs_read(fd, stat.size, 0, vim.schedule_wrap(function(_, data)
        if data == "dark" then
          vim.cmd('DKODark')
        else
          vim.cmd('DKOLight')
        end
        vim.loop.fs_close(fd)
      end))
    end)
  end)
end

M.setup = function ()
  M.apply_darkmode_setting()
  M.monitor_colorscheme()
end

return M
