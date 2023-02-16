local M = {}

---@param haystack string
---@param needle string
---@return boolean found true if needle in haystack
M.starts_with = function (haystack, needle)
  return string.sub(haystack, 1, string.len(needle)) == needle
end

local smallcaps  = 'ᴀʙᴄᴅᴇғɢʜɪᴊᴋʟᴍɴᴏᴘǫʀsᴛᴜᴠᴡxʏᴢ'
local letters    = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ'
---@param text string
M.smallcaps = function(text)
  return vim.fn.tr(vim.fn.toupper(text), letters, smallcaps)
end

return M
