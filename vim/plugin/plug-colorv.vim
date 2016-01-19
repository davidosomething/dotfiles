if !exists('g:plugs["colorv.vim"]') | finish | endif

let g:colorv_no_global_map  = 1
let g:colorv_preview_ftype  = "css,html,less,sass,scss"
let g:colorv_cache_fav      = expand(g:dko_vim_dir . "/.tmp/cache/colorv_cache_fav")
let g:colorv_cache_file     = expand(g:dko_vim_dir . "/.tmp/cache/colorv_cache_file")

