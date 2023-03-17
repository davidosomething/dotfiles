local M = {}

---@param haystack string
---@param needle string
---@return boolean found true if needle in haystack
M.starts_with = function(haystack, needle)
  return haystack:sub(1, needle:len()) == needle
end

-- alt F ғ (ghayn)
-- alt Q ꞯ (currently using ogonek)
local smallcaps =
  "ᴀʙᴄᴅᴇꜰɢʜɪᴊᴋʟᴍɴᴏᴘǫʀsᴛᴜᴠᴡxʏᴢ‹›"
local letters = "ABCDEFGHIJKLMNOPQRSTUVWXYZ<>"
---@param text string
M.smallcaps = function(text)
  return vim.fn.tr(text:upper(), letters, smallcaps)
end

return M
