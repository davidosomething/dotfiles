scriptencoding utf-8
if !exists("g:plugs['vim-airline']") | finish | endif

let g:airline_powerline_fonts = 1
let g:airline_theme = 'bubblegum'

" line number symbol
call dko#init_object('g:airline_symbols')
let g:airline_symbols.linenr   = ''
let g:airline_symbols.paste    = 'ρ'
let g:airline_symbols.readonly = ''

" Strip percentage and other junk from last section of airline
let g:airline_section_z = airline#section#create([ ' %l:%v' ])

" ============================================================================
" Extensions
" ============================================================================

let g:airline#extensions#bufferline#enabled = 0
let g:airline#extensions#capslock#enabled   = 0
let g:airline#extensions#csv#enabled        = 0
let g:airline#extensions#ctrlspace#enabled  = 0
let g:airline#extensions#eclim#enabled      = 0
let g:airline#extensions#hunks#enabled      = 0
let g:airline#extensions#nrrwrgn#enabled    = 0
let g:airline#extensions#promptline#enabled = 0
let g:airline#extensions#syntastic#enabled  = 1
let g:airline#extensions#taboo#enabled      = 0
let g:airline#extensions#tagbar#enabled     = 0
let g:airline#extensions#tmuxline#enabled   = 0
let g:airline#extensions#whitespace#enabled = 0
let g:airline#extensions#windowswap#enabled = 0
let g:airline#extensions#wordcount#enabled  = 0

autocmd vimrc FileType *
      \ unlet! g:airline#extensions#whitespace#checks

" ----------------------------------------------------------------------------
" Extension: anzu
" ----------------------------------------------------------------------------

if exists("g:plugs['vim-anzu']")
  let g:airline#extensions#anzu#enabled = 1
endif

" ----------------------------------------------------------------------------
" Extension: QuickFix
" ----------------------------------------------------------------------------

let g:airline#extensions#quickfix#quickfix_text = 'QF'
let g:airline#extensions#quickfix#location_text = 'LL'

" ----------------------------------------------------------------------------
" Extension: Tabline
" ----------------------------------------------------------------------------

" list buffers ONLY at top
let g:airline#extensions#tabline#enabled = 1
" never show tabs
let g:airline#extensions#tabline#show_tabs = 0
" don't need to indicate whether showing buffers or tabs
let g:airline#extensions#tabline#show_tab_type = 1
" show superscript buffer numbers (buffer_nr_show is off)
let g:airline#extensions#tabline#buffer_idx_mode = 1

" ----------------------------------------------------------------------------
" Extension: vim-virtualenv
" ----------------------------------------------------------------------------

let g:airline#extensions#virtualenv#enabled = 1
