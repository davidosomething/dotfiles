local uis = vim.api.nvim_list_uis()
local has_ui = #uis > 0

return {
  -- https://github.com/angelinuxx/npm-lens.nvim
  -- Parses JSON output of npm outdated --json
  -- Has BufReadPost autocmd
  {
    "angelinuxx/npm-lens.nvim",
    cond = has_ui,
  },

  -- https://github.com/vuki656/package-info.nvim
  -- Parses string output of npm outdated
  -- {
  --   "vuki656/package-info.nvim",
  --   cond = has_ui,
  --   dependencies = "MunifTanjim/nui.nvim",
  --   event = "BufReadPost package.json",
  --   config = function()
  --     require("package-info").setup({
  --       hide_up_to_date = true,
  --     })
  --
  --     local c = require("package-info/utils/constants")
  --     vim.api.nvim_create_autocmd("User", {
  --       group = c.AUTOGROUP,
  --       pattern = c.LOAD_EVENT,
  --       callback = function()
  --         -- execute a groupless autocmd so heirline can update
  --         vim.cmd.doautocmd("User", "DkoPackageInfoStatusUpdate")
  --       end,
  --     })
  --   end,
  -- },
}
