" plugin/csscolors.vim

if exists('g:plugs["Colorizer"]')
  let g:colorizer_auto_filetype = 'scss,vim'
  let g:colorizer_colornames_disable = 1
endif

if exists('g:plugs["colorv.vim"]')
  let g:colorv_no_global_map  = 1
  let g:colorv_preview_ftype  = 'css,html,json,less,sass,scss'
  let g:colorv_cache_fav      = expand(dko#vim_dir . '/.tmp/cache/colorv_cache_fav')
  let g:colorv_cache_file     = expand(dko#vim_dir . '/.tmp/cache/colorv_cache_file')
endif

