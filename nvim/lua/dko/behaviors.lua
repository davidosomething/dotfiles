-- ===========================================================================
-- Change vim behavior via autocommands
-- ===========================================================================

local augroup = function(name, opts)
  opts = opts or {}
  return vim.api.nvim_create_augroup(name, opts)
end
local autocmd = vim.api.nvim_create_autocmd

local appGroup = augroup("dkonvimapp")
autocmd("VimLeavePre", {
  desc = "Remove the remote socket file",
  callback = function()
    if vim.v.servername:find("nvim.sock") then
      vim.loop.fs_unlink(vim.v.servername)
    end
  end,
  group = appGroup,
})

local windowGroup = augroup("dkowindow")
autocmd("VimResized", {
  desc = "Automatically resize windows in all tabpages when resizing Vim",
  callback = function()
    local ok, notify = pcall(require, "notify")
    if ok then
      notify.dismiss({ silent = true, pending = true })
    end
    vim.cmd([[tabdo wincmd =]])
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

autocmd({ "WinEnter", "BufWinEnter", "TermOpen" }, {
  desc = "Start in insert mode when entering a terminal",
  callback = function(args)
    if vim.startswith(vim.api.nvim_buf_get_name(args.buf), "term://") then
      vim.cmd("startinsert")
    end
  end,
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
      lines[i] = line:gsub("%$%{(%w+)%}", function(s)
        return s:len() > 0 and tokens[s] or ""
      end)
    end
    vim.api.nvim_buf_set_lines(0, 0, -1, false, lines)
  end,
  group = readingGroup,
})

autocmd("BufEnter", {
  desc = "Read only mode (un)mappings",
  callback = function()
    local is_editable = require("dko.utils.buffer").is_editable
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
    if vim.loop.fs_stat(args.file).size > 1000 * 1024 then
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

-- @TODO as of nvim-0.9, replace this with ++p somehow? :h :write
autocmd({ "BufWritePre", "FileWritePre" }, {
  desc = "Create missing parent directories on write",
  callback = function(args)
    ---@diagnostic disable-next-line: missing-parameter
    local dir = vim.fs.dirname(args.file)
    if not vim.loop.fs_stat(dir) then
      if vim.fn.mkdir(dir, "p") then
        vim.notify(
          vim.fn.fnamemodify(dir, ":p:~"),
          vim.log.levels.INFO,
          { title = "Created dir on write" }
        )
      end
    end
  end,
  group = augroup("dkosaving"),
})

-- Having issues with this, :Lazy sync sets loclist?
autocmd("DiagnosticChanged", {
  desc = "Sync diagnostics to loclist",
  callback = function(args)
    -- REQUIRED or else neovim will freeze on quit -- some LSP will do a final
    -- DiagnosticChanged before shutdown
    if vim.v.exiting ~= vim.NIL then
      return
    end

    --[[ args = {
      buf = 1,
      data = {
        diagnostics = { {
            bufnr = 1,
            code = "trailing-space",
            col = 28,
            end_col = 29,
            end_lnum = 161,
            lnum = 161,
            message = "Line with postspace.",
            namespace = 34,
            severity = 4,
            source = "Lua Diagnostics.",
            user_data = {
              lsp = {
                code = "trailing-space"
              }
            }
          } }
      },
      event = "DiagnosticChanged",
      file = "/home/davidosomething/.dotfiles/nvim/lua/dko/behaviors.lua",
      group = 10,
      id = 12,
      match = "/home/davidosomething/.dotfiles/nvim/lua/dko/behaviors.lua"
    } ]]

    -- Don't sync diagnostics from unlisted buffers
    if not vim.api.nvim_buf_get_option(args.buf, "buflisted") then
      return
    end

    local original = vim.api.nvim_get_current_win()

    -- Make sure all windows showing the buffer are updated
    local wins = vim.tbl_filter(function(winnr)
      local bufnr = vim.api.nvim_win_get_buf(winnr)
      local ft = vim.api.nvim_buf_get_option(bufnr, "filetype")
      return ft ~= "qf" and bufnr == args.buf
    end, vim.api.nvim_tabpage_list_wins(0))
    for _, winnr in pairs(wins) do
      vim.diagnostic.setloclist({ open = false, winnr = winnr }) -- true would focus empty loclist
      -- open+focus loclist if has entries, else close
      vim.api.nvim_set_current_win(winnr)
      vim.cmd.lwindow()
    end

    vim.api.nvim_set_current_win(original)
  end,
  group = augroup("dkodiagnostic"),
})

-- https://github.com/neovim/neovim/blob/7a44231832fbeb0fe87553f75519ca46e91cb7ab/runtime/lua/vim/lsp.lua#L1529-L1533
-- Happens before on_attach, so can still use on_attach to do more stuff or
-- override this
autocmd("LspAttach", {
  desc = "Bind LSP in buffer",
  callback = function(args)
    --[[
    {
      buf = 1,
      data = {
        client_id = 1
      },
      event = "LspAttach",
      file = "/home/davidosomething/.dotfiles/nvim/lua/dko/behaviors.lua",
      group = 11,
      id = 13,
      match = "/home/davidosomething/.dotfiles/nvim/lua/dko/behaviors.lua"
    }
    ]]
    local bufnr = args.buf
    local client = vim.lsp.get_client_by_id(args.data.client_id)

    -- null-ls hijacks formatexpr, unset it if not tied to a formatter
    -- https://github.com/jose-elias-alvarez/null-ls.nvim/issues/1131
    if
      client.name == "null-ls"
      and not require("null-ls.generators").can_run(
        vim.bo[bufnr].filetype,
        require("null-ls.methods").lsp.FORMATTING
      )
    then
      vim.bo[bufnr].formatexpr = nil
    end

    if not vim.b[bufnr].has_lsp then
      vim.b[bufnr].has_lsp = true
      require("dko.mappings").bind_lsp(bufnr)
    end
  end,
  group = augroup("dkolsp"),
})
