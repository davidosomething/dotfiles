local autocmd = vim.api.nvim_create_autocmd
local uis = vim.api.nvim_list_uis()
local has_ui = #uis > 0

if has_ui then
  local augroup = require("dko.utils.autocmd").augroup

  -- https://vi.stackexchange.com/questions/11892/populate-a-git-commit-template-with-variables
  autocmd("BufRead", {
    pattern = "COMMIT_EDITMSG",
    desc = "Replace tokens in commit-template",
    callback = function()
      local tokens = {}
      tokens.BRANCH = vim
        .system({ "git", "rev-parse", "--abbrev-ref", "HEAD" })
        :wait().stdout
        :gsub("\n", "")

      local lines = vim.api.nvim_buf_get_lines(0, 0, -1, false)
      for i, line in ipairs(lines) do
        lines[i] = line:gsub("%$%{(%w+)%}", function(s)
          return s:len() > 0 and tokens[s] or ""
        end)
      end
      vim.api.nvim_buf_set_lines(0, 0, -1, false, lines)
    end,
    group = augroup("dkogit"),
  })

  -- Bug fix for stale branch name in tabline
  -- Gitsigns updates the value of vim.g.gitsigns_head AFTER calling the autocmd
  -- so sometimes we get a stale value depending on vim scheduler
  -- https://github.com/lewis6991/gitsigns.nvim/blob/5f808b5e4fef30bd8aca1b803b4e555da07fc412/lua/gitsigns.lua#L60-L65
  autocmd("User", {
    pattern = "GitSignsUpdate",
    callback = vim.schedule_wrap(function()
      vim.cmd.redrawtabline()
    end),
    group = augroup("dkogit"),
  })
end
