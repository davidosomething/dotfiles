if !exists("g:plugs['vim-over']") | finish | endif

let g:over_command_line_prompt = "over> "

" <F7> in OverCommandLine mode to exit
let g:over_command_line_key_mappings = {
      \   "\<F7>": "\<Esc>",
      \ }

inoremap <silent> <F7>   <Esc>:OverCommandLine<CR>
nnoremap <silent> <F7>   :OverCommandLine<CR>
vnoremap <silent> <F7>   <Esc>:OverCommandLine<CR>

