" autoload/pj/commands.vim

" ============================================================================
" :Commands and their wildmenu completions
" ============================================================================

" Edit the package.json file
" @TODO support options for opening in same window, or new tab or horizontally
"       split window
function! pj#commands#Edit() abort
  execute 'vsplit ' . b:PJ_file
endfunction

" Edit the package's main file
function! pj#commands#Main() abort
  let l:main = pj#GetValue('main')
  if empty(l:main)
    return
  endif
  execute 'vsplit ' . l:main
endfunction

" Open the package's readme.md in browser
" @TODO if not a URL then edit it
function! pj#commands#Readme() abort
  call pj#commands#OpenUrl(pj#GetValue('readme'))
endfunction

" Forget the previous package.json data and reload it
function! pj#commands#Reload() abort
  call pj#Invalidate()
  call pj#GetJson()
endfunction

" Completion for :PjRun
function! pj#commands#CompleteRun(arglead, cmdline, pos) abort
  return keys(pj#GetValue('scripts'))
endfunction

" @param {String} name of script to run
" @return {Dict} command results
function! pj#commands#Run(name) abort
  if !executable('node') || !executable('npm')
    echoerr 'Vim could not access node and/or npm.'
  endif

  let l:command = 'npm run ' . a:name

  if has('nvim')
    execute 'split | terminal ' . l:command
    return
  endif

  " @TODO -- delegate to Neomake#Sh or dispatch... too lazy to write out
  if exists('*neomake#Sh')
    return neomake#Sh(l:command, function('pj#commands#OpenQf'))
  endif

  return {}
endfunction

" ============================================================================
" Helpers
" ============================================================================

function! pj#commands#OpenQf(...) abort
  copen
endfunction

" @param {String} url to open
function! pj#commands#OpenUrl(url) abort
  if empty(a:url)
    return
  endif

  if has('unix') && executable('xdg-open')
    " https://github.com/vim/vim/blob/890680ca6364386fabb271c85e0755bcaa6a33c1/runtime/autoload/netrw.vim#L5132
    execute 'silent !xdg-open ' . shellescape(a:url, 1)

  elseif has('macunix') && executable('open')
    " https://github.com/vim/vim/blob/890680ca6364386fabb271c85e0755bcaa6a33c1/runtime/autoload/netrw.vim#L5144
    execute 'silent !open ' . shellescape(a:url, 1)

  elseif has('win32unix') && executable('start')
    execute 'silent !start rundll32 url.dll,FileProtocolHandler '
          \. shellescape(a:url, 1)
  endif
endfunction
