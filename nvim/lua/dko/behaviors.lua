-- ===========================================================================
-- Change vim behavior via autocommands
-- ===========================================================================

local function augroup(name)
  return vim.api.nvim_create_augroup(name, { clear = true })
end

local autocmd = vim.api.nvim_create_autocmd

local windowGroup = augroup("dkowindow")
autocmd("VimResized", {
  desc = "Automatically resize windows in all tabpages when resizing Vim",
  command = "tabdo wincmd =",
  group = windowGroup,
})

autocmd("QuitPre", {
  desc = "Auto close corresponding loclist when quitting a window",
  callback = function()
    if vim.bo.filetype ~= "qf" then
      vim.cmd("silent! lclose")
    end
  end,
  nested = true,
  group = windowGroup,
})

autocmd("VimEnter", {
  desc = "Initialize statusline on VimEnter",
  callback = "dkoline#Init",
  nested = true,
  group = augroup("dkostatusline"),
})

local projectGroup = augroup("dkoproject")
autocmd({ "BufNewFile", "BufRead", "BufWritePost" }, {
  desc = "Set dko#project variables on buffers",
  callback = "dko#project#MarkBuffer",
  group = projectGroup,
})

autocmd("BufWritePost", {
  pattern = "*/colors/*.vim",
  desc = "Auto-reload the colorscheme if it was edited in vim",
  callback = function(args)
    vim.cmd.source(args.file)
  end,
  group = augroup("dkocoloredit"),
})

local readingGroup = augroup("dkoreading")
autocmd("BufEnter", {
  desc = "Read only mode (un)mappings",
  callback = function()
    if vim.fn["dko#IsEditable"]("%") == 1 then
      return
    end

    local closebuf = function()
      if vim.fn["dko#IsEditable"]("%") == 1 then
        return
      end
      if vim.fn.winnr("$") > 1 then
        vim.cmd.close()
      else
        vim.cmd.bprevious()
      end
    end
    vim.keymap.set("n", "q", closebuf, { buffer = true })
  end,
  group = readingGroup,
})

autocmd("BufReadPre", {
  desc = "Disable linting and syntax highlighting for large and minified files",
  callback = function(args)
    -- See the treesitter highlight config too
    if vim.fn.getfsize(args.file) > 300 * 1024 then
      vim.cmd.syntax("off")
    end
  end,
  group = readingGroup,
})

autocmd("BufReadPre", {
  pattern = "*.min.*",
  desc = "Disable syntax on minified files",
  command = "syntax off",
  group = readingGroup,
})

autocmd("TextYankPost", {
  desc = "Highlight yanked text after yanking",
  callback = function()
    vim.highlight.on_yank({
      higroup = "IncSearch",
      timeout = 150,
      on_visual = true,
    })
  end,
  group = augroup("dkoediting"),
})

autocmd({ "BufWritePre", "FileWritePre" }, {
  desc = "Create missing parent directories on write",
  callback = function(args)
    ---@diagnostic disable-next-line: missing-parameter
    local dir = vim.fs.dirname(args.file)
    if vim.fn.isdirectory(dir) == 0 then
      vim.fn.mkdir(dir, "p")
    end
  end,
  group = augroup("dkosaving"),
})
