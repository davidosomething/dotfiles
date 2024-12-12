return {
  condition = function()
    return vim.b.did_bind_coc
  end,
  {
    provider = function()
      return " ᴄᴏᴄ "
    end,
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
