return {
  condition = function()
    return vim.b.did_bind_coc
  end,
  {
    provider = " ᴄᴏᴄ ",
    hl = "dkoStatusKey",
  },
  {
    provider = function()
      local output = vim.fn["coc#status"]()
      return (" %s "):format(output)
    end,
    hl = "dkoStatusItem",
  },
}
