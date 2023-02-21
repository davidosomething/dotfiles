return {
  condition = function()
    return require("heirline.conditions").buffer_matches({
      buftype = { "nofile", "prompt", "quickfix" },
      filetype = { "^git.*", "fugitive" },
    })
  end,
  require("dko.heirline.filetype"),
  require("dko.heirline.align"),
}
