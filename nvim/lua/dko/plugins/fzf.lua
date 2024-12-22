local dkomappings = require("dko.mappings")
local dkosettings = require("dko.settings")

return {
  {
    "ibhagwan/fzf-lua",
    -- optional for icon support
    dependencies = "echasnovski/mini.icons",
    config = function()
      local fzf = require("fzf-lua")

      -- https://github.com/ibhagwan/fzf-lua/blob/main/doc/fzf-lua.txt#L643
      fzf.setup({
        winopts = {
          height = 0.90, -- window height
          width = 0.90, -- window width
          preview = {
            default = "bat",
            ---@type 'horizontal'|'vertical'|'flex'
            layout = "vertical",
            vertical = "up:70%", -- up|down:size -- preview goes above the list
          },
          on_create = function()
            -- called once upon creation of the fzf main window
            -- can be used to add custom fzf-lua mappings, e.g:
            --   vim.keymap.set("t", "<C-j>", "<Down>", { silent = true, buffer = true })
            dkomappings.bind_fzf_terminal_mappings()
          end,
        },

        fzf_opts = { ["--layout"] = "reverse-list" }, -- input goes below the list

        actions = {
          -- Below are the default actions, setting any value in these tables will override
          -- the defaults, to inherit from the defaults change [1] from `false` to `true`
          files = {
            true, -- inherit from defaults, rest are overrides:
            ["enter"] = fzf.actions.file_edit,
            ["ctrl-x"] = fzf.actions.file_split,
          },
        },

        previewers = {
          builtin = {
            -- disable tree-sitter syntax highlighting files larger than 100KB
            syntax_limit_b = 1024 * 100, -- 100KB
            treesitter = { enabled = false },
          },
        },
      })
      dkomappings.bind_fzf()

      if dkosettings.get("select") == "fzf" then
        fzf.register_ui_select()
      end
    end,
  },
}
