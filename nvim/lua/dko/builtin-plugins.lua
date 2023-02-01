-- ===========================================================================
-- Built-in plugins
-- ===========================================================================

local builtins = {
  'loaded_2html_plugin',
  'loaded_getscriptPlugin',
  'loaded_gzip',
  'loaded_man',
  'loaded_matchparen', -- Replaced by vim-matchup
  'loaded_LogiPat',
  'loaded_tarPlugin',
  'loaded_tutor_mode_plugin',
  'loaded_zipPlugin',
}
for _, plugin in pairs(builtins) do
  vim.g['loaded_' .. plugin] = 1
end

vim.g.netrw_liststyle = 3 -- netrw in details format when no vimfiler
vim.g.netrw_browsex_viewer = 'dko-open'
