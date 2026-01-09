local uis = vim.api.nvim_list_uis()
local has_ui = #uis > 0

---@type LazySpec
return {
  --- A yank-ring
  --- https://github.com/gbprod/yanky.nvim
  {
    "gbprod/yanky.nvim",
    cond = has_ui and not require("dko.utils.clipboard").should_use_osc52(),
    event = { "BufReadPost", "BufNewFile" },
    config = function()
      require("yanky").setup({
        highlight = { timer = 300 },
      })
      require("dko.mappings").bind_yanky()
    end,
  },
}
