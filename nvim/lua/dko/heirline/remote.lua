return {
  {
    provider = " ⛖ ",
    hl = function()
      if vim.v.servername:find("nvim.sock") then
        return "dkoStatusGood"
      end
      return "dkoStatusError"
    end,
  },
}
