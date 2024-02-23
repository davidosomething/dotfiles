local M = {}

M.capitalize = function(str)
  return (str:gsub("^%l", string.upper))
end

---@param haystack string
---@param needle string
---@return boolean found true if needle in haystack
M.starts_with = function(haystack, needle)
  return type(haystack) == "string" and haystack:sub(1, needle:len()) == needle
end

-- alt F ғ (ghayn)
-- alt Q ꞯ (currently using ogonek)
local smallcaps =
  "ᴀʙᴄᴅᴇꜰɢʜɪᴊᴋʟᴍɴᴏᴘǫʀsᴛᴜᴠᴡxʏᴢ‹›⁰¹²³⁴⁵⁶⁷⁸⁹"
local normal = "ABCDEFGHIJKLMNOPQRSTUVWXYZ<>0123456789"

---@param text string
M.smallcaps = function(text)
  return vim.fn.tr(text:upper(), normal, smallcaps)
end

return M
