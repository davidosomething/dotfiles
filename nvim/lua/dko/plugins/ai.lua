local uis = vim.api.nvim_list_uis()
local has_ui = #uis > 0

return {
  -- https://github.com/aduros/ai.vim
  {
    "aduros/ai.vim",
    -- It's not working https://github.com/aduros/ai.vim/issues/29
    cond = has_ui and vim.env.OPENAI_API_KEY ~= nil and false,
    cmd = { "AI" },
    init = function()
      vim.g.ai_no_mappings = true
    end,
  },

  -- https://github.com/olimorris/codecompanion.nvim
  {
    "olimorris/codecompanion.nvim",
    cmd = {
      "CodeCompanion",
      "CodeCompanionActions",
      "CodeCompanionChat",
      "CodeCompanionCmd",
    },
    cond = has_ui,
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-treesitter/nvim-treesitter",
      "hrsh7th/nvim-cmp", -- Optional: For using slash commands and variables in the chat buffer
      "nvim-telescope/telescope.nvim", -- Optional: For using slash commands
      -- { "stevearc/dressing.nvim", opts = {} }, -- Optional: Improves `vim.ui.select`
    },
    opts = {
      -- display = {
      --   diff = {
      --     provider = "mini_diff",
      --   },
      -- },
      -- opts = {
      -- log_level = "DEBUG",
      -- },
      strategies = {
        chat = {
          adapter = "ollama",
        },
        inline = {
          adapter = "ollama",
        },
        agent = {
          adapter = "ollama",
        },
      },
    },
  },
}
