local uis = vim.api.nvim_list_uis()
local has_ui = #uis > 0
local mappings = require("dko.mappings")

return {
  -- https://github.com/jim-at-jibba/nvim-redraft
  {
    "jim-at-jibba/nvim-redraft",
    build = "cd ts && npm install && npm run build",
    cond = has_ui,
    config = true,
    dependencies = { "folke/snacks.nvim" },
    event = "VeryLazy",
    keys = vim.tbl_values(mappings.nvim_redraft),
    opts = {
      keys = {
        {
          mappings.nvim_redraft.edit,
          function()
            require("nvim-redraft").edit()
          end,
          mode = "v",
          desc = "AI Edit Selection",
        },
        {
          mappings.nvim_redraft.select_model,
          function()
            require("nvim-redraft").select_model()
          end,
          desc = "Select AI Model",
        },
      },
      llm = {
        models = {
          --- requires OPENAI_API_KEY in env
          {
            provider = "openai", -- "openai", "anthropic", or "xai"
            model = "gpt-4o-mini",
          },
          --- requires ANTHROPIC_API_KEY in env
          {
            provider = "anthropic",
            model = "claude-3-5-sonnet-20241022",
            label = "Claude 3.5 Sonnet",
          },
        },
      },
      -- See Configuration section for options
    },
  },
}
