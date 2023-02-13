-- =========================================================================
-- ui: fzf
-- =========================================================================

return {
  -- Use the repo instead of the version in brew since it includes the help
  -- docs for fzf#run()
  {
    "junegunn/fzf",
    dependencies = {
      "junegunn/fzf.vim",
    },
  },
  {
    "junegunn/fzf.vim",
    init = function()
      vim.g.fzf_command_prefix = "FZF"
      vim.g.fzf_layout = { down = "~40%" }
      vim.g.fzf_buffers_jump = 1
    end,
    config = function()
      vim.keymap.set("n", "<A-b>", "<Cmd>FZFBuffers<CR>")
      vim.keymap.set("n", "<A-c>", "<Cmd>FZFCommands<CR>")
      vim.keymap.set("n", "<A-f>", "<Cmd>FZFFiles<CR>")
      vim.keymap.set("n", "<A-g>", "<Cmd>FZFGrepper<CR>")
      vim.keymap.set("n", "<A-m>", "<Cmd>FZFMRU<CR>")
      vim.keymap.set("n", "<A-p>", "<Cmd>FZFProject<CR>")
      vim.keymap.set("n", "<A-r>", "<Cmd>FZFRelevant<CR>")
      vim.keymap.set("n", "<A-s>", "<Cmd>FZFGitStatusFiles<CR>")
      vim.keymap.set("n", "<A-t>", "<Cmd>FZFTests<CR>")
      vim.keymap.set("n", "<A-v>", "<Cmd>FZFVim<CR>")
    end,
  },
}
