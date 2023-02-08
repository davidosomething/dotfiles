scriptencoding utf-8
" vim-smallcaps
"
" Convert highlighted text to ᴜɴɪᴄᴏᴅᴇ sᴍᴀʟʟᴄᴀᴘs
"

let s:cpo_save = &cpoptions
set cpoptions&vim

" ============================================================================


vnoremap <silent><script><special>
      \ <Plug>(dkosmallcaps)
      \ y:<C-U>call setreg('', smallcaps#convert(@"), getregtype(''))<CR>gv""P

" ============================================================================

let &cpoptions = s:cpo_save
unlet s:cpo_save
