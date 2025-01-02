local dkomappings = require("dko.mappings")
local dkosettings = require("dko.settings")
local dkoformat = require("dko.utils.format")
local augroup = require("dko.utils.autocmd").augroup
local autocmd = vim.api.nvim_create_autocmd
local uis = vim.api.nvim_list_uis()
local has_ui = #uis > 0

if has_ui then
  autocmd("VimResized", {
    desc = "Automatically resize windows in all tabpages when resizing Vim",
    callback = function()
      vim.schedule(function()
        vim.cmd("tabdo wincmd =")
      end)
    end,
    group = augroup("dkowindow"),
  })

  autocmd({ "WinEnter", "BufWinEnter", "TermOpen" }, {
    desc = "Start in insert mode when entering a terminal",
    callback = function(args)
      if vim.startswith(vim.api.nvim_buf_get_name(args.buf), "term://") then
        vim.cmd("startinsert")
      end
    end,
    group = augroup("dkowindow"),
  })

  autocmd("BufReadPre", {
    desc = "Disable linting and syntax highlighting for large and minified files",
    callback = function(args)
      -- See the treesitter highlight config too
      if require("dko.utils.buffer").is_huge(args.file) then
        vim.cmd.syntax("manual")
        vim.cmd([[NoMatchParen]])
      end
    end,
    group = augroup("dkoreading"),
  })

  autocmd("BufReadPre", {
    pattern = "*.min.*",
    desc = "Disable syntax on minified files",
    command = "syntax manual",
    group = augroup("dkoreading"),
  })

  autocmd("BufEnter", {
    desc = "Read only mode (un)mappings",
    callback = function()
      local is_editable = require("dko.utils.buffer").is_editable
      if is_editable(0) then
        return
      end

      local closebuf = function()
        if is_editable(0) then
          return
        end
        local totalWindows = vim.fn.winnr("$")
        if totalWindows > 1 then
          vim.cmd.close()
        else
          -- Requires nobuflisted on quickfix!
          vim.cmd.bprevious()
        end
      end
      vim.keymap.set("n", "Q", closebuf, { buffer = true })
      vim.keymap.set("n", "q", closebuf, { buffer = true })
    end,
    group = augroup("dkoreading"),
  })
end

-- yanky.nvim providing this
-- autocmd("TextYankPost", {
--   desc = "Highlight yanked text after yanking",
--   callback = function()
--     vim.highlight.on_yank({
--       higroup = "IncSearch",
--       timeout = 150,
--       on_visual = true,
--     })
--   end,
--   group = augroup("dkoediting"),
-- })

autocmd({ "BufWritePre", "FileWritePre" }, {
  desc = "Create missing parent directories on write",
  callback = function(args)
    local status, result = pcall(function()
      -- this is a remote url
      if args.file:find("://") then
        return
      end
      local dir = assert(
        vim.fn.fnamemodify(args.file, ":h"),
        ("could not get dirname: %s"):format(args.file)
      )
      -- dir already exists
      if vim.fn.getftype(dir) == "dir" then
        return
      end
      assert(vim.fn.mkdir(dir, "p") == 1, ("could not mkdir: %s"):format(dir))
      return assert(
        vim.fn.fnamemodify(dir, ":p:~"),
        ("could not resolve full path: %s"):format(dir)
      )
    end)
    if type(result) == "string" then
      vim.notify(result, vim.log.levels[status and "INFO" or "ERROR"], {
        title = "Create dir on write",
      })
    end
  end,
  group = augroup("dkosaving"),
})

require("dko.behaviors.git")
require("dko.behaviors.lsp")
require("dko.behaviors.qfloclist")
