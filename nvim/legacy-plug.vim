if g:dko_autoinstall_vim_plug
  let s:has_plug = !empty(glob(expand(g:dko#vim_dir . '/autoload/plug.vim')))
  " Load vim-plug and its plugins?
  if !s:has_plug && executable('curl')
    call dkoplug#install#Install()
    let s:has_plug = 1
  endif

  if s:has_plug
    augroup dkoplugupdates
      autocmd User dko-plugins-installed,dko-plugins-updated
            \   if exists(':UpdateRemotePlugins')
            \|    silent! UpdateRemotePlugins
            \|  endif
    augroup END

    command! PI PlugInstall | doautocmd User dko-plugins-installed
    command! PU PlugUpgrade | PlugUpdate | doautocmd User dko-plugins-updated

    let g:plug_window = 'tabnew'
    call plug#begin(g:dko#plug_absdir)
    if empty($VIMNOPLUGS) | call dkoplug#plugins#LoadAll() | endif
    call plug#end()
  endif
endif

