" autoload/dko/lint.vim
"
" Setup coc.nvim and neomake linting

let s:did_setup = 0
let s:did_coc_setup = 0

augroup dkolint
  autocmd!
augroup END

" runs in autocmd
function! dko#lint#SetupNeomake() abort
  if dko#IsNonFile('%') | return | endif
  if &filetype ==# 'sh' | call dko#neomake#bash#Setup() | endif
  if &filetype ==# 'css' | call dko#neomake#css#Setup() | endif
  if &filetype ==# 'lua' | call dko#neomake#lua#Setup() | endif
  if &filetype ==# 'php' | call dko#neomake#php#Setup() | endif
  if &filetype ==# 'scss' | call dko#neomake#scss#Setup() | endif
  if &filetype ==# 'zsh' | let b:neomake_zsh_enabled_makers = [ 'zsh' ] | endif
  call dko#neomake#echint#Setup()
endfunction

" runs in autocmd
function! dko#lint#SetupCoc() abort
  if s:did_coc_setup | return | endif
  let s:did_coc_setup = 1

  "autocmd dkolint CursorHold * silent call CocActionAsync('highlight')
  call coc#config('javascript.validate.enable', 0)

  call dko#lint#Setup()
endfunction

" runs in autocmd
function! dko#lint#Setup() abort
  if !s:did_coc_setup && dkoplug#IsLoaded('coc.nvim')
    return
  endif

  if s:did_setup | return | endif
  let s:did_setup = 1

  " @TODO can use neomake#configure#automake() when blacklist is implemented
  " Keep this last so all the other autocmds happen first
  autocmd dkolint BufWritePost * call dko#lint#LintBuffer()

  autocmd dkolint FileType * call dko#lint#SetupNeomake()
  call dko#lint#SetupNeomake()
endfunction

" bound to <f6> and bufwrite
" Conditionally run Neomake if it is enabled for buffer
function! dko#lint#LintBuffer() abort
  if !dko#IsTypedFile('%') | return | endif
  if dkoplug#IsLoaded('coc') && exists('b:dko_is_coc')
    if &filetype =~# 'javascript'
      call CocAction('reloadExtension', 'coc-eslint')
    endif
    return
  endif

  if dkoplug#IsLoaded('neomake')
    if exists('b:dko_neomake_lint')
      Neomake
      return
    endif

    let l:fts = neomake#utils#get_config_fts(&filetype)
    for l:ft in l:fts
      " Makers disabled for this buffer + ft?
      if exists('b:neomake_' . l:ft . '_enabled_makers')
            \ && empty(b:neomake_{l:ft}_enabled_makers)
        continue
      endif
      " Has makers?
      if len(neomake#GetMakers(l:ft))
        let b:dko_neomake_lint = 1
        Neomake
        return
      endif
    endfor
  endif
endfunction
