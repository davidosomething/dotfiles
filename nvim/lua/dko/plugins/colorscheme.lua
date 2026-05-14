local dev = vim.env.NVIM_DEV ~= nil

return require("dko.utils.lazyspec")(function(ctx)
  ---@type LazySpec
  return {
    {
      "davidosomething/vim-colors-meh",
      cond = ctx.has_ui,
      dependencies = {
        -- { "rakr/vim-two-firewatch", lazy = true },
        -- {
        --   "mcchrish/zenbones.nvim",
        --   lazy = true,
        --   dependencies = { "rktjmp/lush.nvim" },
        -- },
        -- "ntk148v/komau.vim",
        "oskarnurm/koda.nvim",
      },
      dev = dev,
      lazy = false,
      priority = 1000,
      init = function()
        require("dko.settings").set("colors.dark", "meh")
        require("dko.settings").set("colors.light", "koda-glade")
      end,
      config = function()
        vim.cmd.colorscheme("meh")
        if vim.env.TERM_PROGRAM == "WezTerm" then
          require("dko.colors").wezterm_sync()
        end
      end,
    },
  }
end)
