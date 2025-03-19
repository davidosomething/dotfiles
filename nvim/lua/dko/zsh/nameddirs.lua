local M = {}

M.nameddirs = {}

M.async_get_named_dirs = function(bookmarks_file)
  vim.uv.fs_open(bookmarks_file, "r", 438, function(err_open, fd)
    assert(not err_open, err_open)
    vim.uv.fs_fstat(fd, function(err_stat, stat)
      assert(not err_stat, err_stat)
      assert(stat, "file does not exist")
      vim.uv.fs_read(fd, stat.size, 0, function(err_read, data)
        assert(not err_read, err_read)
        vim.uv.fs_close(fd, function(err_close)
          assert(not err_close, err_close)
          for line in data:gmatch("([^\n]*)\n?") do
            local parts = {}
            for part in line:gmatch("[^=]+") do
              parts[#parts + 1] = part
            end
            if parts and parts[1] and parts[2] then
              -- vim.print(parts)
              local name = parts[1]:sub(9) -- remove "hash -d "
              local path = parts[2]:gsub('"(.+)"', "%1")
              M.nameddirs[name] = path
            end
          end
        end)
      end)
    end)
  end)
end

M.find = function(path)
  for shortname, prefix in pairs(M.nameddirs) do
    if vim.startswith(path, prefix) then
      return shortname, prefix
    end
  end
  return nil, nil
end

-- run immediately
M.async_get_named_dirs(os.getenv("HOME") .. "/.local/zshbookmarks")

return M
