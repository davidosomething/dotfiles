local dkomappings = require("dko.mappings")
local dkosettings = require("dko.settings")
local dkoformat = require("dko.utils.format")

-- ===========================================================================
-- Change vim behavior via autocommands
-- ===========================================================================

local uis = vim.api.nvim_list_uis()
local has_ui = #uis > 0

local groups = {}
local augroup = function(name, opts)
  if not groups[name] then
    opts = opts or {}
    groups[name] = vim.api.nvim_create_augroup(name, opts)
  end
  return groups[name]
end

local autocmd = vim.api.nvim_create_autocmd

if has_ui then
  -- @TODO keep an eye on https://github.com/neovim/neovim/issues/23581
  autocmd("WinLeave", {
    desc = "Toggle close->open loclist so it is always under the correct window",
    callback = function()
      if vim.bo.buftype == "quickfix" then
        -- Was in loclist already
        return
      end
      local loclist_winid = vim.fn.getloclist(0, { winid = 0 }).winid
      if loclist_winid == 0 then
        return
      end

      local leaving = vim.api.nvim_get_current_win()
      autocmd("WinEnter", {
        callback = function()
          if vim.bo.buftype == "quickfix" then
            -- Left main window and went into the loclist
            return
          end
          local entering = vim.api.nvim_get_current_win()
          vim.o.eventignore = "all"
          vim.api.nvim_set_current_win(leaving)
          vim.cmd.lclose()
          vim.cmd.lwindow()
          vim.api.nvim_set_current_win(entering)
          vim.o.eventignore = ""
        end,
        once = true,
      })
    end,
    group = augroup("dkowindow"),
  })

  autocmd("User", {
    pattern = "EscEscEnd",
    desc = "Close DKODoctor floats on <Esc><Esc>",
    callback = function()
      require("dko.doctor").close_float()
    end,
    group = augroup("dkodoctor"),
  })

  autocmd("VimResized", {
    desc = "Automatically resize windows in all tabpages when resizing Vim",
    callback = function()
      vim.schedule(function()
        vim.cmd("tabdo wincmd =")
      end)
    end,
    group = augroup("dkowindow"),
  })

  autocmd("QuitPre", {
    desc = "Auto close corresponding loclist when quitting a window",
    callback = function()
      if vim.bo.filetype ~= "qf" then
        vim.cmd("silent! lclose")
      end
    end,
    nested = true,
    group = augroup("dkowindow"),
  })

  autocmd({ "WinEnter", "BufWinEnter", "TermOpen" }, {
    desc = "Start in insert mode when entering a terminal",
    callback = function(args)
      if vim.startswith(vim.api.nvim_buf_get_name(args.buf), "term://") then
        vim.cmd("startinsert")
      end
    end,
    group = augroup("dkowindow"),
  })

  autocmd("BufReadPre", {
    desc = "Disable linting and syntax highlighting for large and minified files",
    callback = function(args)
      -- See the treesitter highlight config too
      if require("dko.utils.buffer").is_huge(args.file) then
        vim.cmd.syntax("manual")
        vim.cmd([[NoMatchParen]])
      end
    end,
    group = augroup("dkoreading"),
  })

  autocmd("BufReadPre", {
    pattern = "*.min.*",
    desc = "Disable syntax on minified files",
    command = "syntax manual",
    group = augroup("dkoreading"),
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
    group = augroup("dkoreading"),
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
    group = augroup("dkoreading"),
  })

  autocmd({ "BufNewFile", "BufRead", "BufFilePost" }, {
    pattern = { "*.lua" },
    desc = "Apply stylua.toml spacing if no editorconfig",
    callback = function()
      vim.schedule(function()
        if not vim.b.editorconfig or vim.tbl_isempty(vim.b.editorconfig) then
          require("dko.editing").from_stylua_toml()
        end
      end)
    end,
    group = augroup("dkoediting"),
  })
end

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
    local status, result = pcall(function()
      -- this is a remote url
      if args.file:find("://") then
        return
      end
      local dir = assert(
        vim.fn.fnamemodify(args.file, ":h"),
        ("could not get dirname: %s"):format(args.file)
      )
      -- dir already exists
      if vim.fn.getftype(dir) == "dir" then
        return
      end
      assert(vim.fn.mkdir(dir, "p") == 1, ("could not mkdir: %s"):format(dir))
      return assert(
        vim.fn.fnamemodify(dir, ":p:~"),
        ("could not resolve full path: %s"):format(dir)
      )
    end)
    if type(result) == "string" then
      vim.notify(result, vim.log.levels[status and "INFO" or "ERROR"], {
        title = "Create dir on write",
      })
    end
  end,
  group = augroup("dkosaving"),
})

if has_ui then
  autocmd("ColorScheme", {
    desc = "Clear heirline color cache",
    callback = function()
      local _, heirline = pcall(require, "heirline")
      if heirline then
        heirline.reset_highlights()
      end
    end,
    group = augroup("dkoheirline"),
  })

  autocmd("User", {
    pattern = "FormattersChanged",
    desc = "Notify neovim a formatter has been added for the buffer",
    callback = vim.schedule_wrap(function()
      vim.cmd.redrawstatus({ bang = true })
    end),
    group = augroup("dkoformatter"),
  })

  -- https://github.com/neovim/neovim/blob/7a44231832fbeb0fe87553f75519ca46e91cb7ab/runtime/lua/vim/lsp.lua#L1529-L1533
  -- LspAttach happens before on_attach, so can still use on_attach to do more stuff or
  -- override this

  autocmd("LspAttach", {
    desc = "Bind LSP related mappings",
    callback = dkomappings.bind_on_lspattach,
    group = augroup("dkolsp"),
  })

  autocmd("LspAttach", {
    desc = "Set flag to format on save when first capable LSP attaches to buffer",
    callback = dkoformat.enable_on_lspattach,
    group = augroup("dkolsp"),
  })

  autocmd("LspDetach", {
    desc = "Unbind LSP related mappings on last client detach",
    callback = dkomappings.unbind_on_lspdetach,
    group = augroup("dkolsp"),
  })

  autocmd("LspDetach", {
    desc = "Unset flag to format on save when last capable LSP detaches from buffer",
    callback = dkoformat.disable_on_lspdetach,
    group = augroup("dkolsp"),
  })

  autocmd("FileType", {
    desc = "Set mappings/format on save for specific filetypes if coc.nvim is enabled",
    callback = function(opts)
      --- order matters here
      if
        dkosettings.get("coc.enabled")
        and vim.tbl_contains(dkosettings.get("coc.fts"), vim.bo.filetype)
      then
        vim.cmd.CocStart()
        dkomappings.bind_coc(opts)
        --- @TODO move this to a tools-based registration
        -- dkoformat.add_formatter("coc")
        -- vim.b.enable_format_on_save = true
      else
        -- explicitly disable coc
        vim.b.coc_enabled = 0
        vim.b.coc_diagnostic_disable = 1
        vim.b.coc_suggest_disable = 1
      end
      dkomappings.bind_snippy()
      dkomappings.bind_completion(opts)
      dkomappings.bind_hover(opts)
    end,
  })

  autocmd("User", {
    pattern = "EscEscEnd",
    desc = "Close coc.nvim floats on <Esc><Esc>",
    callback = function()
      if dkosettings.get("coc.enabled") then
        vim.fn["coc#float#close_all"]()
      end
    end,
    group = augroup("dkolsp"),
  })

  autocmd({ "BufWritePre", "FileWritePre" }, {
    desc = "Format with LSP on save",
    callback = function()
      -- callback gets arg
      -- {
      --   buf = 1,
      --   event = "BufWritePre",
      --   file = "nvim/lua/dko/behaviors.lua",
      --   id = 127,
      --   match = "/home/davidosomething/.dotfiles/nvim/lua/dko/behaviors.lua"
      -- }
      if not vim.b.enable_format_on_save then
        return
      end
      dkoformat.run_pipeline({ async = false })
    end,
    group = augroup("dkolsp"),
  })

  -- temporary fix, winbars not updating

  vim
    .iter({
      "dko.heirline.diagnostics",
    })
    :map(function(name)
      local ok, m = pcall(require, name)
      if ok then
        return m.update
      end
      require("dko.doctor").warn({
        category = "behaviors.nvim",
        message = ("[%s] Lua module `%s` not found"):format(
          "behaviors.nvim",
          name
        ),
      })
      return {}
    end)
    :each(function(events)
      if events[1] == "User" and events["pattern"] then
        autocmd("User", {
          group = events["group"],
          pattern = events["pattern"],
          desc = "FIX - heirline does not always update winbars",
          callback = vim.schedule_wrap(function()
            vim.print("xxx")
            vim.cmd.redrawstatus({ bang = true })
          end),
        })
      else
        for _, event in ipairs(events) do
          local autocmd_exists = vim.fn.exists(("##%s"):format(event)) == 1
          if autocmd_exists then
            autocmd(event, {
              desc = "FIX - heirline does not always update winbars",
              callback = vim.schedule_wrap(function()
                vim.cmd.redrawstatus({ bang = true })
              end),
            })
          end
        end
      end
    end)
end
