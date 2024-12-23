local augroup = require("dko.utils.autocmd").augroup
local autocmd = vim.api.nvim_create_autocmd

local uis = vim.api.nvim_list_uis()
local has_ui = #uis > 0

if has_ui then
  autocmd("BufReadPre", {
    pattern = "COMMIT_EDITMSG",
    desc = "Disable swap on COMMIT_EDITMSG",
    callback = function()
      vim.bo.swapfile = false
    end,
    group = augroup("dkogit"),
  })

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
end
