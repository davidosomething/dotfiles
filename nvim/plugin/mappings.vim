" plugin/mappings.vim
scriptencoding utf-8

" KEEP IDEMPOTENT
" There is no loaded guard on top, so any recursive maps need a silent unmap
" prior to binding. This way this file can be edited and sourced at any time
" to rebind keys.
"
" See after/plugin/search for search mappings like <Esc><Esc>
"

" cpoptions are reset but use <special> when mapping anyway
let s:cpo_save = &cpoptions
set cpoptions&vim

" ============================================================================
" My abbreviations and autocorrect
" ============================================================================

inoreabbrev :lod: ಠ_ಠ
inoreabbrev :flip: (ﾉಥ益ಥ）ﾉ︵┻━┻
inoreabbrev :yuno: ლ(ಠ益ಠლ)
inoreabbrev :strong: ᕦ(ò_óˇ)ᕤ

inoreabbrev unlabeled   unlabelled

inoreabbrev targetted   targeted
inoreabbrev targetting  targeting
inoreabbrev targetter   targeter

inoreabbrev threshhold  threshold
inoreabbrev threshholds thresholds

inoreabbrev removeable  removable

inoreabbrev d'' David O'Trakoun
inoreabbrev o'' O'Trakoun
inoreabbrev m@@ me@davidosomething.com

inoreabbrev kbdopt <kbd>⌥</kbd>
inoreabbrev kbdctrl <kbd>⌃</kbd>
inoreabbrev kbdshift <kbd>⇧</kbd>
inoreabbrev kbdcmd <kbd>⌘</kbd>
inoreabbrev kbdesc <kbd>⎋</kbd>
inoreabbrev kbdcaps <kbd>⇪</kbd>
inoreabbrev kbdtab <kbd>⇥</kbd>
inoreabbrev kbdeject <kbd>⏏︎</kbd>
inoreabbrev kbddel <kbd>⌫</kbd>
inoreabbrev kbdleft <kbd>←</kbd>
inoreabbrev kbdup <kbd>↑</kbd>
inoreabbrev kbdright <kbd>→</kbd>
inoreabbrev kbddown <kbd>↓</kbd>


" ============================================================================
" Commands
" ============================================================================

" In normal mode, jump to command mode with <CR>
" Don't map <CR>, it's a pain to unmap for various window types like quickfix
" where <CR> should jump to the entry, or NetRW or unite or fzf.
"nnoremap  <special>  <CR>  <Esc>:<C-U>

command! Q q

" ============================================================================
" FZF
" ============================================================================

nnoremap  <silent><special>   <A-b>   :<C-U>FZFBuffers<CR>
nnoremap  <silent><special>   <A-c>   :<C-U>FZFCommands<CR>
nnoremap  <silent><special>   <A-f>   :<C-U>FZFFiles<CR>
nnoremap  <silent><special>   <A-g>   :<C-U>FZFGrepper<CR>
nnoremap  <silent><special>   <A-m>   :<C-U>FZFMRU<CR>
nnoremap  <silent><special>   <A-p>   :<C-U>FZFProject<CR>
nnoremap  <silent><special>   <A-r>   :<C-U>FZFRelevant<CR>
nnoremap  <silent><special>   <A-s>   :<C-U>FZFGitStatusFiles<CR>
nnoremap  <silent><special>   <A-t>   :<C-U>FZFTests<CR>
nnoremap  <silent><special>   <A-v>   :<C-U>FZFVim<CR>

" ----------------------------------------------------------------------------
" <Tab> space or real tab based on line contents and cursor position
" ----------------------------------------------------------------------------

function! s:DKO_Tab() abort
  " If characters all the way back to start of line were all whitespace,
  " insert whatever expandtab setting is set to do.
  if strpart(getline('.'), 0, col('.') - 1) =~? '^\s*$'
    return "\<Tab>"
  endif

  " The PUM is closed and characters before the cursor are not all whitespace
  " so we need to insert alignment spaces (always spaces)
  " Calc how many spaces, support for negative &sts values
  let l:sts = (&softtabstop <= 0) ? shiftwidth() : &softtabstop
  let l:sp = (virtcol('.') % l:sts)
  if l:sp == 0 | let l:sp = l:sts | endif
  return repeat(' ', 1 + l:sts - l:sp)
endfunction

silent! iunmap <Tab>
inoremap  <silent><special><expr>  <Tab>     <SID>DKO_Tab()

" Tab inserts a tab, shift-tab should remove it
inoremap <S-Tab> <C-d>

" ============================================================================

let &cpoptions = s:cpo_save
unlet s:cpo_save
