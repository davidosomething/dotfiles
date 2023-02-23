local settings = {
  treesitter = {
    highlight_enabled = false,
  },
}

return {
  get = function(path)
    require("dko.utils.get")(settings, path)
  end,
}
