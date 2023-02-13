local M = {}

local smallcaps  = 'ᴀʙᴄᴅᴇғɢʜɪᴊᴋʟᴍɴᴏᴘǫʀsᴛᴜᴠᴡxʏᴢ'
local letters    = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ'

M.convert = function(text)
  return vim.fn.tr(vim.fn.toupper(text), letters, smallcaps)
end

return M
