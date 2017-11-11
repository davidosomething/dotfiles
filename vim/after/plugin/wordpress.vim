" after/plugin/wordpress.vim
augroup dkowordpresssucksdonkeyballs
  autocmd!

  " No EOL character on files -- specifically for WP VIP PHP
  autocmd BufNewFile,BufReadPre
        \ */wp-content/themes/vip/*
        \ setlocal noeol binary fileformat=dos

  " Indent case: and default: in switch()
  autocmd BufNewFile,BufReadPre
        \ */*content/themes/*.php,*/*content/plugins/*.php,*/mu-plugins/*.php
        \ let b:PHP_vintage_case_default_indent = 1
augroup END
