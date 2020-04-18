" plugin/plug-vim-over.vim

if !dkoplug#Exists('vim-over') | finish | endif

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
      \   "\<A-s>": "\<Plug>(over-cmdline-substitute-jump-string)",
      \   "\<A-p>": "\<Plug>(over-cmdline-substitute-jump-pattern)",
      \ }

let s:cpo_save = &cpoptions
set cpoptions&vim

nnoremap <silent>  \   :<C-U>OverCommandLine<CR>

let &cpoptions = s:cpo_save
unlet s:cpo_save
