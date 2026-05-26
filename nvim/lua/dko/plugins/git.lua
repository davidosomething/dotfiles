local dkosettings = require("dko.settings")

return require("dko.utils.lazyspec")(function(ctx)
  ---@type LazySpec
  return {
    -- show diff when editing a COMMIT_EDITMSG
    {
      "rhysd/committia.vim",
      cond = ctx.is_giteditor,
      lazy = false, -- just in case
      init = function()
        vim.g.committia_open_only_vim_starting = 0
        vim.g.committia_use_singlecolumn = "always"
        --- parse diff from commit template when --cached diff is empty (e.g. --amend)
        vim.g["committia#git#use_verbose"] = 1
      end,
    },

    {
      "lewis6991/gitsigns.nvim",
      event = { "BufReadPost", "BufNewFile" },
      cond = ctx.has_ui,
      opts = {
        on_attach = require("dko.mappings").bind_gitsigns,
        preview_config = {
          border = dkosettings.get("pumborder"),
        },
      },
    },

    {
      "folke/snacks.nvim",
      opts = {
        styles = {
          blame_line = {
            border = dkosettings.get("winborder"),
          },
        },
      },
    },
  }
end)
