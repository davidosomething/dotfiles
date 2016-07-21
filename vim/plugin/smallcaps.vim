" plugin/smallcaps.vim
"
" Convert highlighted text to ᴜɴɪᴄᴏᴅᴇ sᴍᴀʟʟᴄᴀᴘs
"
scriptencoding utf-8

let s:smallcaps  = 'ᴀʙᴄᴅᴇғɢʜɪᴊᴋʟᴍɴᴏᴘǫʀsᴛᴜᴠᴡxʏᴢ'
let s:letters    = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ'

function! s:convert(text)
  return tr(toupper(a:text), s:letters, s:smallcaps)
endfunction

vnoremap <silent><script>
      \ <Plug>(dkosmallcaps)
      \ y:<C-U>call setreg('', <SID>convert(@"), getregtype(''))<CR>gv""P

vmap <Leader>C <Plug>(dkosmallcaps)
