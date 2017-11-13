" autoload/dko/neomake/php.vim

let g:dko#neomake#php#phpcs = {
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

function! dko#neomake#php#Phpcs() abort
  let b:neomake_php_phpcs_args = neomake#makers#ft#php#phpcs().args +
        \ (dko#project#Type() ==# 'wordpress'
        \   ? s:phpcs_wordpress
        \   : s:phpcs_psr2)
endfunction

function! dko#neomake#php#Phpmd() abort
  let l:ruleset_file = dko#project#GetFile('ruleset.xml')

  if !empty(l:ruleset_file)
    " source, format, ruleset(xml file or comma sep list of default rules)
    let b:neomake_php_phpmd_args = [
          \   '%:p',
          \   'text',
          \   l:ruleset_file,
          \ ]
  endif
endfunction
