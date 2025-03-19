local M = {}

M.capitalize = function(str)
  return (str:gsub("^%l", string.upper))
end

M.longest = function(strs)
  local len = 1
  local match
  for _, str in pairs(strs) do
    if str:len() > len then
      len = str:len()
      match = str
    end
  end
  return match, len
end

local smallcaps_mappings = {
  -- alt F ғ (ghayn)
  -- alt Q ꞯ (currently using ogonek)
  alpha = {
    "ABCDEFGHIJKLMNOPQRSTUVWXYZ",
    "ᴀʙᴄᴅᴇꜰɢʜɪᴊᴋʟᴍɴᴏᴘǫʀsᴛᴜᴠᴡxʏᴢ",
  },
  symbols = {
    "‹›",
    "<>",
  },
  numbers = {
    "⁰¹²³⁴⁵⁶⁷⁸⁹",
    "0123456789",
  },
}

---@class SmallcapsOptions
---@field numbers? boolean whether to smallcaps numbers
---@field symbols? boolean whether to smallcaps symbols

---@param text string
---@param options? SmallcapsOptions
M.smallcaps = function(text, options)
  if not text then
    return text
  end

  local result = text:upper()

  result =
    vim.fn.tr(result, smallcaps_mappings.alpha[1], smallcaps_mappings.alpha[2])

  if not options or options.numbers then
    result = vim.fn.tr(
      result,
      smallcaps_mappings.numbers[1],
      smallcaps_mappings.numbers[2]
    )
  end

  if not options or options.symbols then
    result = vim.fn.tr(
      result,
      smallcaps_mappings.symbols[1],
      smallcaps_mappings.symbols[2]
    )
  end

  return result
end

return M
