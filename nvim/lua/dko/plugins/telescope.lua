return {

  {
    "nvim-telescope/telescope-file-browser.nvim",
    dependencies = {
      "nvim-telescope/telescope.nvim",
      "nvim-lua/plenary.nvim",
    },
    config = function()
      require("telescope").load_extension("file_browser")
    end,
  },

  {
    "nvim-telescope/telescope.nvim",
    tag = "0.1.1",
    dependencies = {
      "nvim-lua/plenary.nvim",
      { "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
    },
    config = function()
      local action_state = require("telescope.actions.state")
      local action_utils = require("telescope.actions.utils")
      local function single_or_multi_select(prompt_bufnr)
        local current_picker = action_state.get_current_picker(prompt_bufnr)
        local has_multi_selection = (
          next(current_picker:get_multi_selection()) ~= nil
        )

        if has_multi_selection then
          local results = {}
          action_utils.map_selections(prompt_bufnr, function(selection)
            table.insert(results, selection[1])
          end)

          vim.print(results)

          -- load the selections into buffers list without switching to them
          for _, filepath in ipairs(results) do
            -- not the same as vim.fn.bufadd!
            vim.cmd.badd({ args = { filepath } })
          end

          require("telescope.pickers").on_close_prompt(prompt_bufnr)

          -- switch to newly loaded buffers if on an empty buffer
          if vim.fn.bufname() == "" then
            vim.cmd.bwipeout()
            vim.cmd.buffer(results[1])
          end
          return
        end

        -- if does not have multi selection, open single file
        require("telescope.actions").file_edit(prompt_bufnr)
      end

      require("telescope").setup({
        defaults = {
          file_ignore_patterns = {
            "COMMIT_EDITMSG",
          },
          mappings = {
            i = {
              ["<Esc>"] = "close",
              ["<CR>"] = single_or_multi_select,
            },
          },
          results_title = false,
        },
        extensions = {
          file_browser = {
            hijack_netrw = true,
            layout_strategy = "vertical",
            layout_config = {
              vertical = {
                height = 0.8,
                width = 0.9,
              },
            },
          },
        },
      })

      require("telescope").load_extension("fzf")

      require("dko.mappings").bind_telescope()
    end,
  },
}
