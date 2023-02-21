return {
  {
    provider = " ⛖ ",
    hl = function()
      if string.find(vim.v.servername, "nvim.sock") then
        return "dkoStatusGood"
      end
      return "dkoStatusError"
    end,
  },
}
