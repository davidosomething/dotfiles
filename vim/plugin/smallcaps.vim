scriptencoding utf-8
" plugin/smallcaps.vim
"
" Convert highlighted text to ᴜɴɪᴄᴏᴅᴇ sᴍᴀʟʟᴄᴀᴘs
"

let s:cpo_save = &cpoptions
set cpoptions&vim

" ============================================================================

let s:smallcaps  = 'ᴀʙᴄᴅᴇғɢʜɪᴊᴋʟᴍɴᴏᴘǫʀsᴛᴜᴠᴡxʏᴢ'
let s:letters    = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ'

function! s:convert(text)
  return tr(toupper(a:text), s:letters, s:smallcaps)
endfunction

vnoremap <silent><script>
      \ <Plug>(dkosmallcaps)
      \ y:<C-U>call setreg('', <SID>convert(@"), getregtype(''))<CR>gv""P

vmap <special> <Leader>C <Plug>(dkosmallcaps)

" ============================================================================

let &cpoptions = s:cpo_save
unlet s:cpo_save
