" plugin/plug-increment-activator.vim

" Check for IsPlugged instead of IsLoaded since we lazy load
if !dko#IsPlugged('increment-activator') | finish | endif

let s:cpo_save = &cpoptions
set cpoptions&vim

" ============================================================================

nmap <special><silent> <C-a> <Plug>(increment-activator-increment)
imap <special><silent> <C-a> <Plug>(increment-activator-increment)
nmap <special><silent> <C-x> <Plug>(increment-activator-decrement)
imap <special><silent> <C-x> <Plug>(increment-activator-decrement)

let g:increment_activator_filetype_candidates = {
      \   '_': [
      \     ['absolute', 'relative'],
      \     ['add', 'remove'],
      \     ['before', 'after'],
      \     ['class', 'id'],
      \     ['div', 'p', 'span'],
      \     ['even', 'odd'],
      \     ['h1', 'h2', 'h3', 'h4', 'h5', 'h6'],
      \     ['height', 'width'],
      \     ['horizontal', 'vertical'],
      \     ['inside', 'outside'],
      \     ['left', 'right'],
      \     ['linear', 'radial'],
      \     ['margin', 'padding'],
      \     ['max', 'min'],
      \     ['on', 'off'],
      \     ['png', 'jpg', 'gif'],
      \     ['push', 'pull'],
      \     ['px', '%', 'em'],
      \     ['show', 'hide'],
      \     ['slow', 'normal', 'fast'],
      \     ['small', 'medium', 'large'],
      \     ['top', 'bottom'],
      \     ['ul', 'ol'],
      \     ['up', 'down'],
      \   ],
      \   'gitrebase': [
      \     ['pick', 'squash'],
      \   ],
      \   'javascript': [
      \     [ 'var', 'const', 'let' ],
      \     [ 'private', 'public' ],
      \     [ 'Boolean', 'Error', 'Number', 'Object', 'String' ],
      \     [ 'mouseover', 'mouseout', 'mouseenter', 'mouseleave' ],
      \     [ 'addEventListener', 'removeEventListener' ],
      \   ],
      \   'php': [
      \     [ 'private', 'protected', 'public', 'var' ],
      \     [ 'extends', 'implements' ],
      \   ],
      \   'vim': [
      \     ['nnoremap', 'xnoremap', 'inoremap', 'vnoremap', 'cnoremap', 'onoremap'],
      \     ['nmap', 'xmap', 'imap', 'vmap', 'cmap', 'omap'],
      \   ],
      \ }

" ============================================================================

let &cpoptions = s:cpo_save
unlet s:cpo_save
