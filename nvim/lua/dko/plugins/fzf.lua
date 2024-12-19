local dkomappings = require("dko.mappings")

return {
  {
    "ibhagwan/fzf-lua",
    -- optional for icon support
    dependencies = "echasnovski/mini.icons",
    config = function()
      require("fzf-lua").setup({
        fzf_opts = { ["--layout"] = "reverse-list" }, -- input goes below the list
        winopts = {
          height = 0.90, -- window height
          width = 0.90, -- window width
          preview = {
            ---@type 'horizontal'|'vertical'|'flex'
            layout = "vertical",
            vertical = "up:70%", -- up|down:size -- preview goes above the list
          },
        },
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
      dkomappings.bind_fzf()
    end,
  },
}
