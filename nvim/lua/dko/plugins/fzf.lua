-- local dkomappings = require("dko.mappings")

return {
  {
    "ibhagwan/fzf-lua",
    -- optional for icon support
    dependencies = "echasnovski/mini.icons",
    config = function()
      require("fzf-lua").setup({
        oldfiles = {
          include_current_session = true,
          stat_file = true, -- verify files exist on disk
        },
        previewers = {
          builtin = {
            -- disable tree-sitter syntax highlighting files larger than 100KB
            syntax_limit_b = 1024 * 100, -- 100KB
          },
        },
      })
      -- dkomappings.bind_fzf()
    end,
  },
}
