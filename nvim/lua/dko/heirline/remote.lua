return {
  {
    provider = " 󰴽 ",
    hl = function()
      if vim.v.servername:find("nvim.sock") then
        return "String"
      end
      return "Error"
    end,
  },
}
