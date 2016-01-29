if !exists("g:plugs['vim-over']") | finish | endif

let g:over_command_line_prompt = 'over> '

" <F7> in OverCommandLine mode to exit
let g:over_command_line_key_mappings = {
      \   "\<F7>": "\<Esc>",
      \ }

inoremap <silent> <F11>   <Esc>:OverCommandLine<CR>
nnoremap <silent> <F11>   :OverCommandLine<CR>
vnoremap <silent> <F11>   <Esc>:OverCommandLine<CR>

