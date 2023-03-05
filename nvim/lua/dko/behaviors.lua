-- ===========================================================================
-- Change vim behavior via autocommands
-- ===========================================================================

local function augroup(name)
  return vim.api.nvim_create_augroup(name, {})
end

local autocmd = vim.api.nvim_create_autocmd

local windowGroup = augroup("dkowindow")
autocmd("VimResized", {
  desc = "Automatically resize windows in all tabpages when resizing Vim",
  command = "tabdo wincmd =",
  group = windowGroup,
})

autocmd("BufEnter", {
  desc = "When :q, close if quickfix is the only window",
  callback = function()
    if vim.bo.filetype == "qf" and vim.fn.winnr("$") < 2 then
      vim.cmd.quit()
    end
  end,
  group = windowGroup,
})

autocmd("FileType", {
  pattern = "qf",
  desc = "Skip quickfix windows when :bprevious and :bnext",
  command = "set nobuflisted",
  group = windowGroup,
})

autocmd("QuitPre", {
  desc = "Auto close corresponding loclist when quitting a window",
  callback = function()
    if vim.bo.filetype ~= "qf" then
      vim.cmd("silent! lclose")
    end
  end,
  nested = true,
  group = windowGroup,
})

local projectGroup = augroup("dkoproject")
autocmd({ "BufNewFile", "BufRead", "BufWritePost" }, {
  desc = "Set dko#project variables on buffers",
  callback = "dko#project#MarkBuffer",
  group = projectGroup,
})

local readingGroup = augroup("dkoreading")

-- https://vi.stackexchange.com/questions/11892/populate-a-git-commit-template-with-variables
autocmd("BufRead", {
  pattern = "COMMIT_EDITMSG",
  desc = "Replace tokens in commit-template",
  callback = function()
    local tokens = {
      BRANCH = vim.fn.matchstr(
        vim.fn.system("git rev-parse --abbrev-ref HEAD"),
        "\\p\\+"
      ),
    }

    local lines = vim.api.nvim_buf_get_lines(0, 0, -1, false)
    for i, line in ipairs(lines) do
      lines[i] = string.gsub(line, "%$%{(%w+)%}", function(s)
        return string.len(s) > 0 and tokens[s] or ""
      end)
    end
    vim.api.nvim_buf_set_lines(0, 0, -1, false, lines)
  end,
  group = readingGroup,
})

autocmd("BufEnter", {
  desc = "Read only mode (un)mappings",
  callback = function()
    local is_editable = require('dko.utils.buffer').is_editable
    if is_editable(0) then
      return
    end

    local closebuf = function()
      if is_editable(0) then
        return
      end
      local totalWindows = vim.fn.winnr("$")
      if totalWindows > 1 then
        vim.cmd.close()
      else
        -- Requires nobuflisted on quickfix!
        vim.cmd.bprevious()
      end
    end
    vim.keymap.set("n", "Q", closebuf, { buffer = true })
    vim.keymap.set("n", "q", closebuf, { buffer = true })
  end,
  group = readingGroup,
})

autocmd("BufReadPre", {
  desc = "Disable linting and syntax highlighting for large and minified files",
  callback = function(args)
    -- See the treesitter highlight config too
    if vim.fn.getfsize(args.file) > 1000 * 1024 then
      vim.cmd.syntax("manual")
    end
  end,
  group = readingGroup,
})

autocmd("BufReadPre", {
  pattern = "*.min.*",
  desc = "Disable syntax on minified files",
  command = "syntax manual",
  group = readingGroup,
})

-- yanky.nvim providing this
-- autocmd("TextYankPost", {
--   desc = "Highlight yanked text after yanking",
--   callback = function()
--     vim.highlight.on_yank({
--       higroup = "IncSearch",
--       timeout = 150,
--       on_visual = true,
--     })
--   end,
--   group = augroup("dkoediting"),
-- })

autocmd({ "BufWritePre", "FileWritePre" }, {
  desc = "Create missing parent directories on write",
  callback = function(args)
    ---@diagnostic disable-next-line: missing-parameter
    local dir = vim.fs.dirname(args.file)
    if vim.fn.isdirectory(dir) == 0 then
      vim.fn.mkdir(dir, "p")
    end
  end,
  group = augroup("dkosaving"),
})

-- Having issues with this, :Lazy sync sets loclist?
autocmd("DiagnosticChanged", {
  desc = "Sync diagnostics to loclist",
  callback = function(args)
    -- data = {
    --   diagnostics = { {
    --       bufnr = 5,

    -- Don't sync diagnostics from unlisted buffers
    if
      args.data
      and #args.data.diagnostics > 0
      and vim.fn.getbufvar(args.data.diagnostics[1].bufnr, "&buflisted") == 0
    then
      return
    end

    vim.diagnostic.setloclist({ open = false }) -- true would focus empty loclist

    local window = vim.api.nvim_get_current_win()
    vim.cmd.lwindow() -- open+focus loclist if has entries, else close
    vim.api.nvim_set_current_win(window)
  end,
  group = augroup("dkodiagnostic"),
})

vim.api.nvim_create_autocmd("LspAttach", {
  desc = "Bind LSP in buffer",
  callback = function()
    -- Need to unset this on EVERY LSP attach
    -- https://github.com/jose-elias-alvarez/null-ls.nvim/issues/1131
    vim.bo.formatexpr = nil

    if vim.b.has_lsp then
      return
    end
    vim.b.has_lsp = true

    require("dko.lsp").bind_lsp_mappings()
  end,
  group = vim.api.nvim_create_augroup("dkolsp", {}),
})
