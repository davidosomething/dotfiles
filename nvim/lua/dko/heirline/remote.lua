return {
  provider = " 󰴽 ",
  hl = function()
    -- bin/e listens on nvim.sock, or nvim-tab-<wezterm tab id>.sock in WezTerm
    local servername = vim.v.servername
    if
      servername:find("nvim%.sock$") or servername:find("nvim%-tab%-%d+%.sock$")
    then
      return "String"
    end
    return "Error"
  end,
}
