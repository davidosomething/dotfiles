" init.vim
" Neovim init (in place of vimrc, sources vimrc)

" ============================================================================
" Settings vars
" ============================================================================

" Fallback for vims with no env access like Veonim
" used by plugin/*
let g:vdotdir = empty($VDOTDIR) ? expand('$XDG_CONFIG_DIR/nvim') : $VDOTDIR

let g:dko_rtp_original = &runtimepath

let g:mapleader = "\<Space>"

" Plugin settings
let g:dko_autoinstall_vim_plug = executable('git')
let g:dko_use_completion = executable('node')
let g:dko_use_fzf = exists('&autochdir')

let g:truecolor = has('termguicolors')
      \ && $TERM_PROGRAM !=# 'Apple_Terminal'
      \ && ($COLORTERM ==# 'truecolor' || $DOTFILES_OS ==# 'Darwin')

" ============================================================================
" Settings
" ============================================================================

lua require('dko.providers')
lua require('dko.opt')
lua require('dko.builtin-plugins')
lua require('dko.builtin-syntax')
lua require('dko.behaviors')
lua require('dko.mappings')
lua require('dko.terminal')

" ----------------------------------------
" Filetype: python
" ----------------------------------------

" $VIMRUNTIME/syntax/python.vim
let g:python_highlight_all = 1

" ----------------------------------------
" Filetype: sh
" ----------------------------------------

" $VIMRUNTIME/syntax/sh.vim - always assume bash
let g:is_bash = 1

" ----------------------------------------
" Filetype: vim
" ----------------------------------------

" $VIMRUNTIME/syntax/vim.vim
" disable mzscheme, tcl highlighting
let g:vimsyn_embed = 'lpPr'

" ============================================================================
" Plugins
" ============================================================================

" ----------------------------------------------------------------------------
" Plugins: autoinstall vim-plug, define plugins, install plugins if needed
" ----------------------------------------------------------------------------

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

" ============================================================================
" Security
" ============================================================================

" Disallow unsafe local vimrc commands
" Leave down here since it trims local settings
set secure

" vim: sw=2 :
