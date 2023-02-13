-- =========================================================================
-- Plugins that aid in the creation of neovim config and plugins
-- =========================================================================

return {
  -- measure startuptime
  {
    "dstein64/vim-startuptime",
    cmd = "StartupTime",
    init = function()
      vim.g.startuptime_tries = 10
    end,
  },

  -- `:Bufferize messages` to get messages (or any :command) in a new buffer
  {
    "AndrewRadev/bufferize.vim",
    cmd = "Bufferize",
    init = function()
      vim.g.bufferize_command = "tabnew"
    end,
    config = function()
      vim.api.nvim_create_user_command("Bmessages", "Bufferize messages", {
        desc = "Open messages in new buffer",
      })
    end,
  },

  -- @TODO nvim 0.9 has :Inspect ?
  {
    "cocopon/colorswatch.vim",
    dependencies = {
      "cocopon/inspecthi.vim",
    },
    lazy = true,
  },
  {
    "cocopon/inspecthi.vim",
    cmd = "Inspecthi",
    keys = {
      {
        "zs",
        "<Cmd>Inspecthi<CR>",
        desc = "Show highlight groups under cursor",
        silent = true,
      },
    },
  },
}
