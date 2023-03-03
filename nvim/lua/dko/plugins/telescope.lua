return {

  {
    "nvim-telescope/telescope-file-browser.nvim",
    dependencies = {
      "nvim-telescope/telescope.nvim",
      "nvim-lua/plenary.nvim",
    },
    config = function()
      local t = require("telescope")
      t.load_extension("file_browser")

      vim.keymap.set("n", "<A-e>", function()
        t.extensions.file_browser.file_browser({
          hidden = true, -- show hidden
        })
      end, { desc = "Telescope: pick existing buffer" })
    end,
  },

  {
    "nvim-telescope/telescope.nvim",
    tag = "0.1.1",
    dependencies = {
      "nvim-lua/plenary.nvim",
      { "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
      "tsakirist/telescope-lazy.nvim",
    },
    config = function()
      local t = require("telescope")

      t.setup({
        defaults = {
          file_ignore_patterns = {
            "COMMIT_EDITMSG",
          },
          mappings = {
            i = {
              ["<Esc>"] = require("telescope.actions").close,
            },
          },
          results_title = false,
        },
      })

      t.load_extension("fzf")

      local themes = require("telescope.themes")
      local builtin = require("telescope.builtin")

      vim.keymap.set("n", "<A-b>", function()
        builtin.buffers(themes.get_ivy({}))
      end, { desc = "Telescope: pick existing buffer" })

      vim.keymap.set("n", "<A-f>", function()
        -- https://github.com/nvim-telescope/telescope.nvim/wiki/Configuration-Recipes#falling-back-to-find_files-if-git_files-cant-find-a-git-directory
        vim.fn.system("git rev-parse --is-inside-work-tree")
        local finder = vim.v.shell_error == 0 and builtin.git_files
          or builtin.find_files
        finder(themes.get_ivy({}))
      end, { desc = "Telescope: pick files in CWD" })

      vim.keymap.set("n", "<A-g>", function()
        builtin.live_grep(themes.get_ivy({}))
      end, { desc = "Telescope: live grep CWD" })

      vim.keymap.set("n", "<A-m>", function()
        builtin.oldfiles(themes.get_ivy({}))
      end, { desc = "Telescope: pick from previously opened files" })

      vim.keymap.set("n", "<A-p>", function()
        local project_root = vim.fn["dko#project#GetRoot"]()

        -- fallback to cwd git root
        if not project_root or string.len(project_root) == 0 then
          project_root = vim.fn["dko#git#GetRoot"](vim.fn.getcwd())
        end

        if not project_root or string.len(project_root) == 0 then
          vim.notify(
            "Not in a project",
            vim.log.levels.ERROR,
            { title = "<A-p>" }
          )
          return
        end

        builtin.find_files(themes.get_ivy({
          prompt_title = "Files in " .. project_root,
          cwd = project_root,
        }))
      end, {
        desc = "Telescope: pick from previously opened files in current project root",
      })

      vim.keymap.set("n", "<A-s>", function()
        builtin.git_status(themes.get_ivy({}))
      end, { desc = "Telescope: pick from git status files" })

      vim.keymap.set("n", "<A-t>", function()
        builtin.find_files(themes.get_ivy({
          prompt_title = "Find tests",
          search_dirs = {
            "./test/",
            "./tests/",
            "./spec/",
            "./specs/",
          },
        }))
      end, { desc = "Telescope: pick files in CWD" })

      vim.keymap.set("n", "<A-v>", function()
        builtin.find_files(themes.get_ivy({
          prompt_title = "Find in neovim configs",
          cwd = vim.fn.stdpath("config"),
          hidden = true,
        }))
      end, { desc = "Telescope: pick from vim config files" })

      vim.keymap.set("n", "<A-x>", function()
        t.extensions.file_browser.file_browser()
      end, { desc = "Telescope: pick from vim config files" })
    end,
  },
}
