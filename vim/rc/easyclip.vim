if !exists('g:plugs["vim-easyclip"]') | finish | endif

" explicitly do NOT remap s/S to paste register
let g:EasyClipUseSubstituteDefaults = 0

" save yanks in a file and persist
let g:EasyClipShareYanks = 1
let g:EasyClipShareYanksDirectory = glob(expand(g:dko_vim_dir . '/.cache'))

imap gcr <Plug>(EasyClipRing)

