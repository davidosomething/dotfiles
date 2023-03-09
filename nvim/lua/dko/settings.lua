local settings = {
  heirline = {
    show_buftype = false,
  },
  treesitter = {
    highlight_enabled = false,
  },
}

return {
  get = function(path)
    require("dko.utils.get")(settings, path)
  end,
}
