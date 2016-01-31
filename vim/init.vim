" neovim init

let g:dko_nvim_dir = fnamemodify(resolve(expand('$MYVIMRC')), ':p:h')

try
  " Neovim-qt Guifont command
  command -nargs=? Guifont call rpcnotify(0, 'Gui', 'SetFont', "<args>") | let g:Guifont="<args>"
  " Set the font to DejaVu Sans Mono:h13
  Guifont Fira Mono For Powerline:h8
endtry

execute 'source ' . g:dko_nvim_dir . '/vimrc'

if has('gui_running')
  set lines=60 columns=180              " 2 panes wide
  "execute 'source ' . g:dko_nvim_dir . '/gvimrc'
endif

