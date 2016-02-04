" plugin/clipboard.vim

if exists('g:plugs["vim-easyclip"]')

  " ======================================================================
  " EasyClip
  " ======================================================================

  " explicitly do NOT remap s/S to paste register
  let g:EasyClipUseSubstituteDefaults = 0

  " save yanks in a file and persist
  let g:EasyClipShareYanks = 1
  let g:EasyClipShareYanksDirectory = glob(expand(g:dko_vim_dir . '/.tmp/cache'))

  imap <c-v> <plug>EasyClipInsertModePaste
  cmap <c-v> <plug>EasyClipCommandModePaste

  " ======================================================================
  " EasyClipRing
  " ======================================================================

  if exists('g:plugs["EasyClipRing.vim"]')
    imap gcr <Plug>(EasyClipRing)
  endif

endif

