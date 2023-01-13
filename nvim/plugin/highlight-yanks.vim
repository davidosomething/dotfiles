augroup dkohighlightyank
  autocmd!
augroup END

if !has('nvim-0.5') | finish | endif

autocmd dkohighlightyank TextYankPost *
      \ lua vim.highlight.on_yank
      \ {higroup="IncSearch", timeout=150, on_visual=true}
