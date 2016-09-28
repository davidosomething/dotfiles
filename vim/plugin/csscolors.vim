" plugin/csscolors.vim

if dko#IsPlugged('Colorizer')
  let g:colorizer_auto_filetype = 'scss,vim'
  let g:colorizer_colornames_disable = 1
endif

if dko#IsPlugged('colorv.vim')
  let g:colorv_no_global_map  = 1
  let g:colorv_preview_ftype  = 'css,html,json,less,sass,scss'
  let g:colorv_cache_fav      = expand(g:dko#vim_dir . '/.tmp/cache/colorv_cache_fav')
  let g:colorv_cache_file     = expand(g:dko#vim_dir . '/.tmp/cache/colorv_cache_file')
endif

