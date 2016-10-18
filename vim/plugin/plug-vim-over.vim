" plugin/plug-vim-over.vim
if !dko#IsPlugged('vim-over') | finish | endif
let s:cpo_save = &cpoptions
set cpoptions&vim

" ============================================================================

let g:over_command_line_prompt = 'over> '

" <Fk> in OverCommandLine mode to exit
" Can probably rewrite this as a range :<
let g:over_command_line_key_mappings = {
      \   "\<F1>": "\<Esc>",
      \   "\<F2>": "\<Esc>",
      \   "\<F3>": "\<Esc>",
      \   "\<F4>": "\<Esc>",
      \   "\<F5>": "\<Esc>",
      \   "\<F6>": "\<Esc>",
      \   "\<F7>": "\<Esc>",
      \   "\<F8>": "\<Esc>",
      \   "\<F9>": "\<Esc>",
      \   "\<F10>": "\<Esc>",
      \   "\<F11>": "\<Esc>",
      \   "\<F12>": "\<Esc>",
      \ }

nnoremap <silent>  \   :<C-u>OverCommandLine<CR>

" ============================================================================

let &cpoptions = s:cpo_save
unlet s:cpo_save
