return {
  {
    "davidosomething/vim-colors-meh",
    dependencies = {
      --"rakr/vim-two-firewatch",
      {
        "mcchrish/zenbones.nvim",
        lazy = true,
        dependencies = { "rktjmp/lush.nvim" },
      },
    },
    dev = true,
    lazy = false,
    priority = 1000,
    init = function()
      -- require("dko.settings").set("colors.dark", "meh")
      -- require("dko.settings").set("colors.light", "zenbones")
    end,
    config = function()
      vim.cmd.colorscheme("meh")
      if vim.env.TERM_PROGRAM == "WezTerm" then
        require("dko.colors").wezterm_sync()
      end
    end,
  },
}
