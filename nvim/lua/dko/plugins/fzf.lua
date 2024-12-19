-- local dkomappings = require("dko.mappings")

return {
  {
    "ibhagwan/fzf-lua",
    -- optional for icon support
    dependencies = "echasnovski/mini.icons",
    config = function()
      -- calling `setup` is optional for customization
      require("fzf-lua").setup({})
      -- dkomappings.bind_fzf()
    end,
  },
}
