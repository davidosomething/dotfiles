local augroup = require("dko.utils.autocmd").augroup

local autocmd = vim.api.nvim_create_autocmd
local Methods = vim.lsp.protocol.Methods

---@class LspAutocmdArgs
---@field buf number
---@field data { client_id: number }
---@field event "LspAttach"|"LspDetach"
---@field file string e.g. "/home/davidosomething/.dotfiles/nvim/lua/dko/behaviors.lua"

-- https://github.com/neovim/neovim/blob/7a44231832fbeb0fe87553f75519ca46e91cb7ab/runtime/lua/vim/lsp.lua#L1529-L1533
-- LspAttach happens before on_attach, so can still use on_attach to do more stuff or
-- override this

autocmd("LspAttach", {
  desc = "Bind LSP related mappings",

  ---@param args LspAutocmdArgs
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
    if vim.bo[bufnr].buftype == "prompt" then
      return
    end
    local client = vim.lsp.get_client_by_id(args.data.client_id)
    if client then -- just to shut up type checking
      require("dko.mappings.lsp").bind_lsp(bufnr)
    end
  end,
  group = augroup("dkolsp"),
})

autocmd("LspAttach", {
  desc = "Add capable LSP as formatter when attaches to buffer",
  callback = function(args)
    local bufnr = args.buf
    local client = vim.lsp.get_client_by_id(args.data.client_id)

    --- Not all formatters claim to support the method at the time of this
    --- autocmd. See Methods.client_registerCapability in ../dko/lsp.lua
    if client and client:supports_method(Methods.textDocument_formatting) then
      require("dko.utils.format").add_formatter(bufnr, client.name, {})
    end
  end,
  group = augroup("dkolsp"),
})

autocmd("LspDetach", {
  desc = "Unbind LSP related mappings on last client detach",
  --[[
    {
      buf = 1,
      data = {
        client_id = 4
      },
      event = "LspDetach",
      file = "/home/davidosomething/.dotfiles/README.md",
      group = 13,
      id = 23,
      match = "/home/davidosomething/.dotfiles/README.md"
    }
  ]]
  callback = function(args)
    local bufnr = args.buf
    local key = "b" .. bufnr

    -- No mappings on buffer
    if require("dko.mappings.lsp").bound.lsp[key] == nil then
      vim.b.did_bind_lsp = false -- just in case
      return
    end

    -- check for clients with definition support, since that's one of the primary
    -- purposes of keybinding...
    local clients = vim.lsp.get_clients({
      bufnr = bufnr,
      method = Methods.textDocument_definition,
    })
    if #clients == 0 then -- Last LSP attached
      if vim.fn.bufwinnr(bufnr) > -1 then
        vim.notify(
          ("No %s providers remaining."):format(Methods.textDocument_definition),
          vim.log.levels.INFO,
          { title = "[LSP]", render = "wrapped-compact" }
        )
        require("dko.mappings.lsp").unbind_lsp(bufnr, "lsp")
      end
    end
  end,
  group = augroup("dkolsp"),
})

autocmd("LspDetach", {
  desc = "Unset flag to format on save IF last formatter detaches from buffer",
  callback = function(args)
    -- was already disabled manually?
    if not vim.b.enable_format_on_save then
      return
    end
    -- Unregister the client from formatters (and update heirline)
    local detached_client = vim.lsp.get_client_by_id(args.data.client_id)
    if detached_client ~= nil then
      require("dko.utils.format").remove_formatter(
        args.buf,
        detached_client.name
      )
    end
  end,
  group = augroup("dkolsp"),
})

autocmd("FileType", {
  desc = "Set mappings/format on save for specific filetypes if coc.nvim is enabled",
  callback = function(opts)
    local dkosettings = require("dko.settings")

    local use_coc = dkosettings.get("coc.enabled")
      and vim.tbl_contains(dkosettings.get("coc.fts"), vim.bo.filetype)

    --- order matters here
    if use_coc then
      vim.cmd.CocStart()
      require("dko.mappings.lsp").bind_coc(opts)
      vim.bo.formatexpr = "CocAction('formatSelected')"

      --- @TODO move this to a tools-based registration
      -- require("dko.utils.format").add_formatter("coc")
      -- vim.b.enable_format_on_save = true
    else
      -- explicitly disable coc
      vim.b.coc_enabled = 0
      vim.b.coc_diagnostic_disable = 1
      vim.b.coc_suggest_disable = 1
    end

    local dkomappings = require("dko.mappings")
    dkomappings.bind_snippy()
    dkomappings.bind_completion(opts)

    if opts.match == "lua" then
      -- In 0.11 it's supposed to jump to module in same repo/rtp/package path, but not
      -- quite the way I want it.
      require("dko.mappings.lua").bind_gf()
    end
  end,
  group = augroup("dkolsp"),
})

-- Triggered after the coc services have started.
-- If you want to trigger an action of coc after Vim has started, this
-- autocmd should be used because coc is always started asynchronously.
autocmd("User", {
  pattern = "CocNvimInit",
  callback = function()
    require("dko.behaviors.escesc").add(function()
      if
        require("dko.settings").get("coc.enabled")
        and vim.fn.exists("*coc#float#close_all")
      then
        vim.fn["coc#float#close_all"](1)
        vim.fn["coc#notify#close_all"]()
      end
    end, "Close coc.nvim floats and notifications on <Esc><Esc>")
  end,
  group = augroup("dkolsp"),
})

-- ===========================================================================
-- Formatting
-- ===========================================================================

autocmd({ "BufWritePre", "FileWritePre" }, {
  desc = "Format with LSP on save",
  callback = function(args)
    if not vim.uv.fs_stat(args.file) then
      vim.b.newfile = 1
    end
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
    require("dko.utils.format").run_pipeline({ async = false })
  end,
  group = augroup("dkolsp"),
})

--- Need to restart coc-eslint for newly created files
--- https://github.com/neoclide/coc-eslint#features
autocmd({ "BufWritePost", "FileWritePost" }, {
  desc = "Restart coc-eslint if saved file for first time",
  callback = function()
    if vim.b.newfile == 1 then
      vim.b.newfile = nil
      vim.cmd.CocCommand("eslint.restart")
    end
  end,
  group = augroup("dkolsp"),
})
