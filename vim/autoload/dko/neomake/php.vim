" autoload/dko/neomake/php.vim

let s:phpcs_psr2 = [ '--standard=PSR2' ]

let s:phpcs_wordpress = [
      \   '--standard=WordPress-Extra',
      \   '--runtime-set', 'installed_paths', expand('~/src/wpcs'),
      \   '--exclude=WordPress.PHP.YodaConditions',
      \ ]

function! dko#neomake#php#Setup() abort
  let l:safeft = neomake#utils#get_ft_confname(&filetype)
  if exists('b:did_dkoneomake_' . l:safeft) | return | endif
  let b:did_dkoneomake_{l:safeft} = 1

  call dko#neomake#LocalMaker({
        \   'ft':     'php',
        \   'maker':  'phpcs',
        \   'exe':    'vendor/bin/phpcs',
        \ })

  call dko#neomake#php#Phpcs()
  call dko#neomake#php#Phpmd()
endfunction

function! dko#neomake#php#Phpcs() abort
  let b:neomake_php_phpcs_args = neomake#makers#ft#php#phpcs().args +
        \ (index(dko#project#Type(), 'wordpress') >= 0
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
