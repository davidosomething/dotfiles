-- ===========================================================================
-- Change vim behavior via autocommands
-- ===========================================================================

local windowGroup = vim.api.nvim_create_augroup('dkowindow', { clear = true })
vim.api.nvim_create_autocmd('VimResized', {
  desc = 'Automatically resize windows when resizing Vim',
  command = 'wincmd =',
  group = windowGroup,
})

local restorePositionGroup = vim.api.nvim_create_augroup('dkorestoreposition', { clear = true })
vim.api.nvim_create_autocmd('BufWinEnter', {
  desc = 'Restore last cursor position when opening file',
  callback = 'dko#RestorePosition',
  group = restorePositionGroup,
})

vim.api.nvim_create_autocmd('QuitPre' , {
  desc = 'Auto close corresponding loclist when quitting a window',
  command = [[ if &filetype != 'qf' | silent! lclose | endif ]],
  nested = true,
  group = windowGroup,
})

local statusGroup = vim.api.nvim_create_augroup('dkostatusline', { clear = true })
if vim.fn['dkoplug#IsLoaded']('coc.nvim') == 1 then
  vim.api.nvim_create_autocmd('User', {
    pattern = 'CocNvimInit',
    desc = 'Initialize statusline after coc has started',
    nested = true,
    callback = 'dkoline#Init',
    group = statusGroup,
  })
else
  vim.api.nvim_create_autocmd('VimEnter', {
    desc = 'Initialize statusline on VimEnter',
    nested = true,
    callback = 'dkoline#Init',
    group = statusGroup,
  })
end

local projectGroup = vim.api.nvim_create_augroup('dkoproject', { clear = true })
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

local colorschemeGroup = vim.api.nvim_create_augroup('dkocoloredit', { clear = true })
vim.api.nvim_create_autocmd('BufWritePost', {
  pattern = '*/colors/*.vim',
  desc = 'Auto-reload the colorscheme if it was edited in vim',
  command = [[so <afile>]],
  group = colorschemeGroup,
})

local readonlyGroup = vim.api.nvim_create_augroup('dkoreadonly', { clear = true })
vim.api.nvim_create_autocmd('BufEnter', {
  desc = 'Read only mode (un)mappings',
  callback = 'dko#readonly#Unmap',
  group = readonlyGroup,
})

local hugefileGroup = vim.api.nvim_create_augroup('dkohugefile', { clear = true })
vim.api.nvim_create_autocmd('BufReadPre', {
  desc = 'Disable linting and syntax highlighting for large and minified files',
  command = [[
  if getfsize(expand("%")) > 10000000
    syntax off
    let b:dko_hugefile = 1
  endif
  ]],
  group = hugefileGroup,
})

vim.api.nvim_create_autocmd('BufReadPre', {
  desc = 'Disable syntax on minified files',
  pattern = '*.min.*',
  command = 'syntax off',
  group = hugefileGroup,
})

local uiGroup = vim.api.nvim_create_augroup('dkoediting', { clear = true })

local highlightOnYank = function ()
  vim.highlight.on_yank({
    higroup = "IncSearch",
    timeout = 150,
    on_visual = true
  })
end
vim.api.nvim_create_autocmd('TextYankPost', {
  desc = 'Highlight yanked text after yanking',
  callback = highlightOnYank,
  group = uiGroup,
})

local writingGroup = vim.api.nvim_create_augroup('dkoautomkdir', { clear = true })
local automkdir = function (args)
  ---@diagnostic disable-next-line: missing-parameter
  local dir = vim.fs.dirname(args.file)
  if vim.fn.isdirectory(dir) == 0 then
    vim.fn.mkdir(dir, 'p')
  end
end
vim.api.nvim_create_autocmd({ 'BufWritePre', 'FileWritePre' }, {
  desc = 'Create missing parent directories on write',
  callback = automkdir,
  group = writingGroup,
})
