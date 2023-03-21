local settings = {
  grepper = {
    ignore_file = vim.fn.expand("$DOTFILES") .. "/" .. "ag/dot.ignore",
  },
  heirline = {
    show_buftype = false,
  },
  treesitter = {
    -- @TODO until I update vim-colors-meh with treesitter @matches
    highlight_enabled = false,
  },
}

return {
  get = function(path)
    return require("dko.utils.get")(settings, path)
  end,
}
