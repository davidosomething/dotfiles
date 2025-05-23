local uis = vim.api.nvim_list_uis()
local has_ui = #uis > 0

return {
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

  {
    -- @TODO remove after nvim 0.11 released
    "ojroques/nvim-osc52",
    -- Prefer builtin osc52. Will be initialized in after/plugin/clipboard.lua
    cond = has_ui
      and not require("dko.utils.clipboard").has_builtin_osc52()
      and require("dko.utils.clipboard").should_use_osc52(),
    config = function()
      local function copy(lines, _)
        require("osc52").copy(table.concat(lines, "\n"))
      end
      local function paste()
        local contents = vim.fn.getreg("") --[[@as string]]
        return { vim.fn.split(contents, "\n"), vim.fn.getregtype("") }
      end
      vim.g.clipboard = {
        name = "nvim-osc52",
        copy = { ["+"] = copy, ["*"] = copy },
        paste = { ["+"] = paste, ["*"] = paste },
      }

      local registers_to_copy = {
        "", -- unnamed, e.g. yy
        "+",
      }
      vim.api.nvim_create_autocmd("TextYankPost", {
        callback = function()
          if
            vim.v.event.operator == "y"
            and vim.tbl_contains(registers_to_copy, vim.v.event.regname)
          then
            require("osc52").copy_register("+")
          end
        end,
        desc = "copy + yanks into osc52",
      })
    end,
  },
}
