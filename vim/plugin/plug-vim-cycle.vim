" plugin/plug-vim-cycle.vim

scriptencoding utf-8

" Check for IsPlugged instead of IsLoaded since we lazy load
if !dko#IsPlugged('vim-cycle') | finish | endif

let s:cpo_save = &cpoptions
set cpoptions&vim

" ============================================================================
" Enable lazy loading

let g:cycle_no_mappings = 1

silent! nunmap <C-a>
silent! nunmap <C-x>
silent! vunmap <C-a>
silent! vunmap <C-x>
nmap    <special><silent> <C-x> <Plug>CyclePrev:redraw!<CR>
nmap    <special><silent> <C-a> <Plug>CycleNext:redraw!<CR>
vmap    <special><silent> <C-x> <Plug>CyclePrev:redraw!<CR>
vmap    <special><silent> <C-a> <Plug>CycleNext:redraw!<CR>

noremap <special><silent> <Plug>CycleFallbackPrev <C-x>:redraw!<CR>
noremap <special><silent> <Plug>CycleFallbackNext <C-a>:redraw!<CR>
" map <special><silent> <Plug>CycleFallbackNext <Plug>SpeedDatingUp

" Normally this is handled by cycle, but we miss the first call for lazy load
augroup dkocycle
  autocmd!
  autocmd User vim-cycle call cycle#reset_ft_groups()
augroup END

" ============================================================================

let g:cycle_default_groups = [
      \   [['true', 'false']],
      \   [['yes', 'no']],
      \   [['on', 'off']],
      \   [['==', '!=']],
      \   [['and', 'or']],
      \   [['before', 'after']],
      \   [['inside', 'outside']],
      \   [['in', 'out']],
      \   [['even', 'odd']],
      \   [['min', 'max']],
      \   [['get', 'set']],
      \   [['add', 'remove']],
      \   [['to', 'from']],
      \   [['read', 'write']],
      \   [['only', 'except']],
      \   [['without', 'with']],
      \   [['exclude', 'include']],
      \   [['show', 'hide']],
      \   [['height', 'width']],
      \   [['horizontal', 'vertical']],
      \   [['portrait', 'landscape']],
      \   [['linear', 'radial']],
      \   [['margin', 'padding']],
      \   [['up', 'down']],
      \   [['left', 'right']],
      \   [['top', 'bottom']],
      \   [['first', 'last']],
      \   [['small', 'medium', 'large']],
      \   [['absolute', 'relative', 'fixed', 'sticky']],
      \   [['asc', 'desc']],
      \   [['{:}', '[:]', '(:)'], 'sub_pairs'],
      \   [['Sunday', 'Monday', 'Tuesday', 'Wednesday', 'Thursday',
      \     'Friday', 'Saturday'], 'hard_case', {'name': 'Days'}],
      \   [['h1', 'h2', 'h3', 'h4', 'h5', 'h6'], 'sub_tag'],
      \   [['ul', 'ol'], 'sub_tag'],
      \ ]

let g:cycle_default_groups_for_javascript = [
      \   [['var', 'let', 'const']],
      \   [['mouseover', 'mouseout', 'mouseenter', 'mouseleave']],
      \ ]

let g:cycle_default_groups_for_php = [
      \   [['private', 'protected', 'public', 'var']],
      \   [['extends', 'implements']],
      \ ]

let g:cycle_default_groups_for_vim = [
      \   [['g:', 'b:', 'l:', 's:']],
      \   [['map', 'nmap', 'xmap', 'imap', 'vmap', 'cmap', 'omap']],
      \   [['noremap', 'nnoremap', 'xnoremap', 'inoremap', 'vnoremap',
      \     'cnoremap', 'onoremap']],
      \   [['unmap', 'nunmap', 'xunmap', 'iunmap', 'vunmap',
      \     'cunmap', 'ounmap']],
      \   [['<special>', '<silent>', '<buffer>', '<expr>']],
      \ ]

" ============================================================================

let &cpoptions = s:cpo_save
unlet s:cpo_save
