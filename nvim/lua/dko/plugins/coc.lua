local uis = vim.api.nvim_list_uis()
local has_ui = #uis > 0

---@type LazySpec
return {
  -- Using this for tsserver specifically, faster results than nvim-lsp
  {
    "neoclide/coc.nvim",
    branch = "release",
    cond = has_ui and require("dko.settings").get("coc.enabled"),
    init = function()
      -- Don't use watchman until this is properly resolved
      -- https://github.com/neoclide/coc.nvim/issues/4490
      -- if vim.fn.executable("watchman") == 0 then
      --   require("dko.doctor").warn({
      --     category = "coc",
      --     message = "[coc] `watchman` not found",
      --   })
      -- end

      vim.g.coc_start_at_startup = true
      vim.g.coc_global_extensions = {
        -- since it gives code actions unified with tsserver
        "coc-eslint",
        "coc-json",
        -- use when prettier config is present but eslint-plugin-prettier is NOT
        "coc-prettier",
        -- for K and completion, but we still use the nvim lsp one too
        -- until I can figure out how to rebuild TWValues
        "@yaegassy/coc-tailwindcss3",
        "coc-tsserver",
      }
    end,
  },
}
