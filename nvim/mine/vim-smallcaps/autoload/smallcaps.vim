let s:smallcaps  = 'ᴀʙᴄᴅᴇғɢʜɪᴊᴋʟᴍɴᴏᴘǫʀsᴛᴜᴠᴡxʏᴢ'
let s:letters    = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ'

function! smallcaps#convert(text) abort
  return tr(toupper(a:text), s:letters, s:smallcaps)
endfunction
