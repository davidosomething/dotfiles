-- ===========================================================================
-- Change vim behavior via autocommands
-- ===========================================================================

local function augroup(name)
  return vim.api.nvim_create_augroup(name, { clear = true })
end

local windowGroup = augroup('dkowindow')
vim.api.nvim_create_autocmd('VimResized', {
  desc = 'Automatically resize windows when resizing Vim',
  command = 'wincmd =',
  group = windowGroup,
})

vim.api.nvim_create_autocmd('QuitPre' , {
  desc = 'Auto close corresponding loclist when quitting a window',
  command = [[ if &filetype != 'qf' | silent! lclose | endif ]],
  nested = true,
  group = windowGroup,
})

vim.api.nvim_create_autocmd('VimEnter', {
  desc = 'Initialize statusline on VimEnter',
  nested = true,
  callback = 'dkoline#Init',
  group = augroup('dkostatusline'),
})

local projectGroup = augroup('dkoproject')
vim.api.nvim_create_autocmd({ 'BufNewFile', 'BufRead', 'BufWritePost' }, {
  desc = 'Set dko#project variables on buffers',
  callback = 'dko#project#MarkBuffer',
  group = projectGroup,
})

vim.api.nvim_create_autocmd('User', {
  pattern = 'CocNvimInit',
  desc = 'Auto lint buffers using coc.nvim and other plugins',
  callback = 'dko#lint#SetupCoc',
  group = projectGroup,
})

vim.api.nvim_create_autocmd('User', {
  pattern = 'neomake',
  desc = 'Auto lint buffers using neomake and other plugins',
  callback = 'dko#lint#Setup',
  group = projectGroup,
})

vim.api.nvim_create_autocmd('BufWritePost', {
  pattern = '*/colors/*.vim',
  desc = 'Auto-reload the colorscheme if it was edited in vim',
  command = [[so <afile>]],
  group = augroup('dkocoloredit'),
})

local readingGroup = augroup('dkoreading')
vim.api.nvim_create_autocmd('BufEnter', {
  desc = 'Read only mode (un)mappings',
  callback = 'dko#readonly#Unmap',
  group = readingGroup,
})

vim.api.nvim_create_autocmd('BufReadPre', {
  desc = 'Disable linting and syntax highlighting for large and minified files',
  command = [[
  if getfsize(expand("%")) > 10000000
    syntax off
    let b:dko_hugefile = 1
  endif
  ]],
  group = readingGroup,
})

vim.api.nvim_create_autocmd('BufReadPre', {
  desc = 'Disable syntax on minified files',
  pattern = '*.min.*',
  command = 'syntax off',
  group = readingGroup,
})

vim.api.nvim_create_autocmd('TextYankPost', {
  desc = 'Highlight yanked text after yanking',
  callback = function()
    vim.highlight.on_yank({
      higroup = "IncSearch",
      timeout = 150,
      on_visual = true
    })
  end,
  group = augroup('dkoediting'),
})

vim.api.nvim_create_autocmd({ 'BufWritePre', 'FileWritePre' }, {
  desc = 'Create missing parent directories on write',
  callback = function(args)
    ---@diagnostic disable-next-line: missing-parameter
    local dir = vim.fs.dirname(args.file)
    if vim.fn.isdirectory(dir) == 0 then
      vim.fn.mkdir(dir, 'p')
    end
  end,
  group = augroup('dkosaving'),
})
