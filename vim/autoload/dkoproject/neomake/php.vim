if !dkoplug#plugins#IsLoaded('neomake') | finish | endif

let g:dkoproject#neomake#php#local_phpcs = {
      \   'ft':     'php',
      \   'maker':  'phpcs',
      \   'exe':    'vendor/bin/phpcs',
      \ }

let s:phpcs_psr2 = [ '--standard=PSR2' ]

let s:phpcs_wordpress = [
      \   '--standard=WordPress-Extra',
      \   '--runtime-set', 'installed_paths', expand('~/src/wpcs'),
      \   '--exclude=WordPress.PHP.YodaConditions',
      \ ]

function! dkoproject#neomake#php#Phpcs() abort
  let b:neomake_php_phpcs_args = neomake#makers#ft#php#phpcs().args +
        \ (dkoproject#ProjectType() ==# 'wordpress'
        \   ? s:phpcs_wordpress
        \   : s:phpcs_psr2)
endfunction

function! dkoproject#neomake#php#Phpmd() abort
  let l:ruleset_file = dkoproject#GetFile('ruleset.xml')

  if !empty(l:ruleset_file)
    " source, format, ruleset(xml file or comma sep list of default rules)
    let b:neomake_php_phpmd_args = [
          \   '%:p',
          \   'text',
          \   l:ruleset_file,
          \ ]
  endif
endfunction
