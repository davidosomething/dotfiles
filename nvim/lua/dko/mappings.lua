local dkobuffer = require("dko.utils.buffer")
local dkosettings = require("dko.settings")

local map = vim.keymap.set

--- wrap handler with buffer assertions
local function emap(modes, keys, handler, opts)
  map(modes, keys, function()
    if vim.bo.buftype == "nofile" then
      return ""
    end
    if type(handler) == "function" then
      return handler()
    end
    return handler
  end, opts)
end

local M = {}

map("n", "<Esc><Esc>", function()
  vim.cmd.doautoall("User EscEscStart")
  -- Clear / search term
  vim.fn.setreg("/", "")
  -- Stop highlighting searches
  vim.cmd.nohlsearch()
  vim.cmd.redraw({ bang = true })
  vim.cmd.doautoall("User EscEscEnd")
end, { desc = "Clear UI" })

-- ===========================================================================
-- Window / Buffer manip
-- ===========================================================================

map("n", "]t", vim.cmd.tabn, { desc = "Next tab" })
map("n", "[t", vim.cmd.tabp, { desc = "Prev tab" })

map("n", "<BS>", function()
  -- only in non-floating
  if vim.api.nvim_win_get_config(0).relative == "" then
    return "<C-^>"
  end
end, {
  expr = true,
  desc = "Prev buffer with <BS> backspace in normal (C-^ is kinda awkward)",
})

local resizeOpts =
  { desc = "Resize window with Shift+DIR, can take a count #<S-Dir>" }
map("n", "<S-Up>", "<C-W>+", resizeOpts)
map("n", "<S-Down>", "<C-W>-", resizeOpts)
map("n", "<S-Left>", "<C-w><", resizeOpts)
map("n", "<S-Right>", "<C-w>>", resizeOpts)

map("n", "<Leader>x", function()
  dkobuffer.close()
end, { desc = "Remove buffer (try without closing window)" })

map("n", "<Leader>l", function()
  require("dko.utils.loclist").toggle()
end, { desc = "Toggle location list" })

-- ===========================================================================
-- Switch mode
-- ===========================================================================

map({ "c", "i" }, "jj", "<Esc>", { desc = "Back to normal mode" })

-- ===========================================================================
-- Visual mode tweaks
-- ===========================================================================

local visualArrowOpts = { desc = "Visual move by display lines" }
map("v", "<Down>", "gj", visualArrowOpts)
map("v", "<Up>", "gk", visualArrowOpts)

-- ===========================================================================
-- cd shortcuts
-- ===========================================================================

map(
  "n",
  "<Leader>cd",
  "<Cmd>cd! %:h<CR>",
  { desc = "cd to current buffer path" }
)

map("n", "<Leader>..", "<Cmd>cd! ..<CR>", { desc = "cd up a level" })

map("n", "<Leader>cr", function()
  local root = require("dko.utils.project").get_git_root()
  if root then
    if vim.uv.chdir(root) == 0 then
      vim.notify(root, vim.log.levels.INFO, { title = "Changed directory" })
    end
  end
end, { desc = "cd to current buffer's git root" })

-- ===========================================================================
-- :edit shortcuts
-- ===========================================================================

map("n", "<Leader>ecr", function()
  require("dko.utils.file").edit_closest("README.md")
end, { desc = "Edit closest README.md" })

map("n", "<Leader>epj", function()
  require("dko.utils.file").edit_closest("package.json")
end, { desc = "Edit closest package.json" })

map("n", "<Leader>evi", function()
  vim.cmd.edit(vim.fn.stdpath("config") .. "/init.lua")
end, { desc = "Edit init.lua" })

map("n", "<Leader>evm", function()
  vim.cmd.edit(vim.fn.stdpath("config") .. "/lua/dko/mappings.lua")
end, { desc = "Edit mappings.lua" })

-- =============================================================================
-- doctor
-- =============================================================================

map("n", "<A-\\>", function()
  require("dko.doctor").toggle_float()
end, { desc = "Toggle dko.doctor float" })

-- ===========================================================================
-- Buffer: Reading
-- ===========================================================================

map({ "i", "n" }, "<F1>", "<NOP>", { desc = "Disable help shortcut key" })

map("n", "<F1>", function()
  local help = require("dko.utils.help")
  local cexpr = vim.fn.expand("<cexpr>")
  local res = help.cexpr(cexpr)
  vim.print({ cexpr, res })
  if res and pcall(vim.cmd.help, res.match) then
    return
  end

  local line = vim.api.nvim_get_current_line()
  res = help.line(line)
  vim.print({ line, res })
  if res then
    vim.cmd.help(res.match)
  end
end, { desc = "Show vim help for <cexpr> or current line" })

map("n", "<Leader>yn", function()
  local res = vim.fn.expand("%:t", false, false)
  if type(res) ~= "string" then
    return
  end
  if res == "" then
    vim.notify(
      "Buffer has no filename",
      vim.log.levels.ERROR,
      { title = "Failed to yank filename", render = "compact" }
    )
    return
  end
  vim.fn.setreg("+", res)
  vim.notify(res, vim.log.levels.INFO, { title = "Yanked filename" })
end, { desc = "Yank the filename of current buffer" })

map("n", "<Leader>yp", function()
  local res = vim.fn.expand("%:p", false, false)
  if type(res) ~= "string" then
    return
  end
  res = res == "" and vim.uv.cwd() or res
  if res:len() then
    vim.fn.setreg("+", res)
    vim.notify(res, vim.log.levels.INFO, { title = "Yanked filepath" })
  end
end, { desc = "Yank the full filepath of current buffer" })

-- ===========================================================================
-- Buffer: Movement
-- ===========================================================================

map("n", "<Leader>mm", function()
  require("dko.utils.movemode").toggle()
end, { desc = "Toggle move mode" })

map("", "H", "^", { desc = "Change H to alias ^" })
map("", "L", "g_", { desc = "Change L to alias g_" })

-- https://stackoverflow.com/questions/4256697/vim-search-and-highlight-but-do-not-jump#comment91750564_4257175
map(
  "n",
  "*",
  "m`<Cmd>keepjumps normal! *``<CR>",
  { desc = "Don't jump on first * -- simpler vim-asterisk" }
)

-- ===========================================================================
-- Buffer: Edit contents
-- ===========================================================================

map("n", "<A-=>", function()
  require("dko.utils.format").run_pipeline({ async = false })
end, {
  desc = "Fix and format buffer with dko.utils.format.run_pipeline",
})

local visualTabOpts = {
  desc = "<Tab> indents selected lines in Visual",
  remap = true,
}
map("v", "<Tab>", ">", visualTabOpts)
map("v", "<S-Tab>", "<", visualTabOpts)

map("n", "<Leader>q", "@q", { desc = "Quickly apply macro q" })

local reselectOpts = { desc = "Reselect visual block after indent" }
map("x", "<", "<gv", reselectOpts)
map("x", ">", ">gv", reselectOpts)

map("n", "<Leader>,", "$r,", { desc = "Replace last character with a comma" })
map(
  "n",
  "<Leader>;",
  "$r;",
  { desc = "Replace last character with a semi-colon" }
)

for _, v in pairs({ "=", "-", "." }) do
  map({ "n", "i" }, "<Leader>f" .. v, function()
    require("dko.utils.hr").fill(v)
  end, { desc = ("Append horizontal rule of %s up to &textwidth"):format(v) })
end

map("x", "<Leader>C", function()
  -- @TODO replace with https://github.com/neovim/neovim/pull/13896
  vim.api.nvim_feedkeys("y", "nx", false)
  local selection = vim.fn.getreg('"')
  if type(selection) ~= "string" then
    return
  end
  local converted = require("dko.utils.string").smallcaps(selection)
  vim.fn.setreg('"', converted)
  vim.api.nvim_feedkeys('gv""P', "nx", false)
end, { desc = "Convert selection to smallcaps" })

map("n", "dd", function()
  if vim.api.nvim_get_current_line():match("^%s*$") then
    return '"_dd'
  else
    return "dd"
  end
end, { desc = "Smart dd, don't yank empty lines", expr = true })

-- ===========================================================================
-- <Tab> behavior
-- ===========================================================================

--[[ " <Tab> space or real tab based on line contents and cursor position
  " The PUM is closed and characters before the cursor are not all whitespace
  " so we need to insert alignment spaces (always spaces)
  " Calc how many spaces, support for negative &sts values
  let l:sts = (&softtabstop <= 0) ? shiftwidth() : &softtabstop
  let l:sp = (virtcol('.') % l:sts)
  if l:sp == 0 | let l:sp = l:sts | endif
  return repeat(' ', 1 + l:sts - l:sp)
endfunction ]]

map("i", "<Tab>", function()
  -- If characters all the way back to start of line were all whitespace,
  -- insert whatever expandtab setting is set to do.
  local current_line = dkobuffer.get_cursorline_contents()
  local all_spaces_regex = "^%s*$"
  if current_line:match(all_spaces_regex) then
    return "<Tab>"
  end

  -- Insert appropriate amount of spaces instead of real tabs
  local sts = vim.bo.softtabstop <= 0 and vim.fn.shiftwidth()
    or vim.bo.softtabstop
  -- How many spaces to insert after the current cursor to get to the next sts
  local spaces_from_cursor_to_next_sts = vim.fn.virtcol(".") % sts
  if spaces_from_cursor_to_next_sts == 0 then
    spaces_from_cursor_to_next_sts = sts
  end

  -- Insert whitespace to next softtabstop
  -- E.g. sts = 4, cursor at _,
  --          1234123412341234
  -- before   abc_
  -- after    abc _
  -- before   abc _
  -- after    abc     _
  -- before   abc    _
  -- after    abc     _
  return (" "):rep(1 + sts - spaces_from_cursor_to_next_sts)
end, { expr = true, desc = "Tab should insert spaces" })

map("i", "<S-Tab>", "<C-d>", {
  desc = "Tab inserts a tab, shift-tab should remove it",
})

-- ===========================================================================
-- Diagnostic mappings
-- ===========================================================================

-- @TODO remove - default as of https://github.com/neovim/neovim/commit/73034611c25d16df5e87c8afb2d339a03a91bd0d/
map("n", "[d", function()
  vim.diagnostic.goto_prev({
    float = dkosettings.get("diagnostics.goto_float"),
  })
end, { desc = "Go to prev diagnostic and open float" })

-- @TODO remove - default as of https://github.com/neovim/neovim/commit/73034611c25d16df5e87c8afb2d339a03a91bd0d/
map("n", "]d", function()
  vim.diagnostic.goto_next({
    float = dkosettings.get("diagnostics.goto_float"),
  })
end, { desc = "Go to next diagnostic and open float" })

-- @TODO start using <c-w><c-d> as of https://github.com/neovim/neovim/commit/73034611c25d16df5e87c8afb2d339a03a91bd0d/
map("n", "<C-W>d", function()
  vim.diagnostic.open_float()
end, { desc = "Open diagnostic float at cursor" })
map("n", "<C-W><C-D>", "<C-W>d", {
  remap = true,
  desc = "Open diagnostic float at cursor",
})

-- ===========================================================================
-- Tree-sitter utils
-- ===========================================================================

map("n", "ss", function()
  vim.print(vim.treesitter.get_captures_at_cursor())
end, { desc = "Print treesitter captures under cursor" })

map("n", "sy", function()
  local captures = vim.treesitter.get_captures_at_cursor()
  if #captures == 0 then
    vim.notify(
      "No treesitter captures under cursor",
      vim.log.levels.ERROR,
      { title = "Yank failed", render = "compact" }
    )
    return
  end

  local parsedCaptures = vim
    .iter(captures)
    :map(function(capture)
      return ("@%s"):format(capture)
    end)
    :totable()
  local resultString = vim.inspect(parsedCaptures)
  vim.fn.setreg("+", resultString .. "\n")
  vim.notify(
    resultString,
    vim.log.levels.INFO,
    { title = "Yanked capture", render = "compact" }
  )
end, { desc = "Copy treesitter captures under cursor" })

-- ===========================================================================
-- Buffer: LSP integration
-- Mix of https://github.com/neovim/nvim-lspconfig#suggested-configuration
-- and :h lsp
-- ===========================================================================

---@param method string
---@return boolean -- true if telescope was succesfully called
local function telescope_builtin(method)
  local ok, builtin = pcall(require, "telescope.builtin")
  if ok then
    builtin[method]({
      -- always show in picker so i can choose how to open it (e.g. split,
      -- vsplit)
      jump_type = "never",
      layout_strategy = "vertical",
    })
    return true
  end
  return false
end

-- Bindings for vim.lsp. Conflicts with bind_coc
-- LspAttach autocmd callback
---@param bufnr number
M.bind_lsp = function(bufnr)
  if vim.b.did_bind_lsp then -- First LSP attached
    return
  end
  vim.b.did_bind_lsp = true

  ---@param opts table
  ---@return table opts with silent and buffer set
  local function lsp_opts(opts)
    opts.silent = true
    opts.buffer = bufnr
    return opts
  end

  map("n", "gD", function()
    vim.lsp.buf.declaration()
  end, lsp_opts({ desc = "LSP declaration" }))

  map("n", "gd", function()
    return telescope_builtin("lsp_definitions") or vim.lsp.buf.definition()
  end, lsp_opts({ desc = "LSP definition" }))

  map("n", "gi", function()
    return telescope_builtin("lsp_implementations")
      or vim.lsp.buf.implementation()
  end, lsp_opts({ desc = "LSP implementation" }))

  map({ "n", "i" }, "<C-g>", function()
    vim.lsp.buf.signature_help()
  end, lsp_opts({ desc = "LSP signature_help" }))

  --map('n', '<space>wa', vim.lsp.buf.add_workspace_folder, bufopts)
  --map('n', '<space>wr', vim.lsp.buf.remove_workspace_folder, bufopts)
  --[[ map('n', '<space>wl', function()
    print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
  end, bufopts) ]]

  map("n", "<Leader>D", function()
    return telescope_builtin("lsp_type_definitions")
      or vim.lsp.buf.type_definition()
  end, lsp_opts({ desc = "LSP type_definition" }))

  map("n", "<Leader>rn", function()
    vim.lsp.buf.rename()
  end, lsp_opts({ desc = "LSP rename" }))

  local code_action = {}

  code_action.tca = function()
    local tca_ok, tca = pcall(require, "tiny-code-action")
    if tca_ok then
      tca.code_action()
      return true
    end
    return false
  end

  code_action.ap = function()
    local ap_ok, ap = pcall(require, "actions-preview")
    if ap_ok then
      ap.code_actions()
      return true
    end
    return false
  end

  map("n", "<Leader><Leader>", function()
    if dkosettings.get("lsp.code_action") == "tiny-code-action" then
      if code_action.tca() or code_action.ap() then
        return
      end
    elseif code_action.ap() or code_action.tca() then
      return
    end
    vim.lsp.buf.code_action()
  end, lsp_opts({ desc = "LSP Code Action" }))

  map("n", "gr", function()
    return telescope_builtin("lsp_references")
      ---@diagnostic disable-next-line: missing-parameter
      or vim.lsp.buf.references()
  end, lsp_opts({ desc = "LSP references" }))
end

-- autocmd callback
M.bind_on_lspattach = function(args)
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
  if client then -- just to shut up type checking
    M.bind_lsp(bufnr)
  end
end

-- @TODO
M.unbind_on_lspdetach = function()
  -- local bufnr = args.buf
  -- local clients = vim.lsp.get_clients({ bufnr = bufnr })
  -- if #clients == 0 then -- Last LSP attached
  -- unbind mappings...
  -- vim.b.did_bind_lsp = false
  -- end
end

-- Bind "K" to
-- jump into active coc float, or
-- show definition float, or
-- jump/show LSP float
M.bind_hover = function(opts)
  -- default vim.ksp is done for us in $VIMRUNTIME/lua/vim/lsp.lua
  -- as of https://github.com/neovim/neovim/pull/24331
  --map("n", "K", vim.lsp.buf.hover, lsp_opts({ desc = "LSP hover" }))

  map("n", "K", function()
    -- Jump into active coc float OR do a definitionHover
    -- This part is taken from coc#float$jump
    -- https://github.com/neoclide/coc.nvim/blob/master/autoload/coc/float.vim#L28C1-L35C12
    if vim.b.did_bind_coc then
      local winids = vim.fn["coc#float#get_float_win_list"]()
      if #winids > 0 then
        vim.fn.win_gotoid(winids[1]) --- 1 indexed !
      elseif vim.api.nvim_eval("coc#rpc#ready()") then
        -- Same as doHover but includes definition contents from definition provider when possible
        vim.fn.CocActionAsync("definitionHover")
      end
    else
      vim.lsp.buf.hover()
    end
  end, { desc = "coc hover action", buffer = opts.buf, silent = true })
end

-- Bind <C-Space> to open nvim-cmp
-- Bind <C-n> <C-p> to pick based on coc or nvim-cmp open
-- Bind <C-j> <C-k> to scroll coc or nvim-cmp attached docs window
M.bind_completion = function(opts)
  local _, cmp = pcall(require, "cmp")

  map("n", "<C-Space>", function()
    vim.cmd.startinsert({ bang = true })
    vim.schedule(cmp.complete)
  end, { desc = "In normal mode, `A`ppend and start nvim-cmp completion" })

  map("i", "<C-Space>", function()
    vim.fn["coc#pum#close"]("cancel")
    cmp.complete()
  end, { desc = "In insert mode, start nvim-cmp completion" })

  map("i", "<Plug>(DkoCmpNext)", function()
    cmp.select_next_item()
  end)
  map("i", "<Plug>(DkoCmpPrev)", function()
    cmp.select_prev_item()
  end)
  map("i", "<C-n>", function()
    if cmp.visible() then
      return "<Plug>(DkoCmpNext)"
    end
    if vim.b.did_bind_coc then
      return vim.fn["coc#pum#visible"]() == 0 and vim.fn["coc#refresh"]()
        or vim.fn["coc#pum#next"](1)
    end
  end, { expr = true, buffer = opts.buf, remap = true, silent = true })
  map("i", "<C-p>", function()
    if cmp.visible() then
      return "<Plug>(DkoCmpPrev)"
    end
    if vim.b.did_bind_coc then
      return vim.fn["coc#pum#visible"]() == 0 and vim.fn["coc#refresh"]()
        or vim.fn["coc#pum#prev"](1)
    end
  end, { expr = true, buffer = opts.buf, remap = true, silent = true })

  map("i", "<Plug>(DkoCmpScrollUp)", function()
    cmp.mapping.scroll_docs(-4)
  end)
  map("i", "<Plug>(DkoCmpScrollDown)", function()
    cmp.mapping.scroll_docs(4)
  end)
  map("i", "<C-k>", function()
    if cmp.visible() then
      return "<Plug>(DkoCmpScrollUp)"
    end
    if vim.b.did_bind_coc and vim.fn["coc#float#has_scroll"]() == 1 then
      return vim.fn["coc#float#scroll"](1)
    end
  end, {
    expr = true,
    buffer = opts.buf,
    nowait = true,
    remap = true,
    silent = true,
  })
  map("i", "<C-j>", function()
    if cmp.visible() then
      return "<Plug>(DkoCmpScrollDown)"
    end
    if vim.b.did_bind_coc and vim.fn["coc#float#has_scroll"]() == 1 then
      return vim.fn["coc#float#scroll"](0)
    end
  end, {
    expr = true,
    buffer = opts.buf,
    nowait = true,
    remap = true,
    silent = true,
  })
  map("n", "<C-j>", function()
    if vim.b.did_bind_coc and vim.fn["coc#float#has_scroll"]() == 1 then
      return vim.fn["coc#float#scroll"](1)
    end
  end, {
    expr = true,
    buffer = opts.buf,
    nowait = true,
    remap = true,
    silent = true,
  })
  map("n", "<C-k>", function()
    if vim.b.did_bind_coc and vim.fn["coc#float#has_scroll"]() == 1 then
      return vim.fn["coc#float#scroll"](0)
    end
  end, {
    expr = true,
    buffer = opts.buf,
    nowait = true,
    remap = true,
    silent = true,
  })
end

-- Bindings for coc.nvim. Conflicts with bind_lsp.
-- opts = {
--   buf = 1,
--   event = "FileType",
--   file = "app/components/Navigation.tsx",
--   id = 26,
--   match = "typescriptreact"
-- }
M.bind_coc = function(opts)
  if vim.b.did_bind_lsp then
    vim.notify(
      "Tried to bind_coc but bind_lsp was already called",
      vim.log.levels.ERROR
    )
    return
  end
  -- make sure bind_lsp doesn't overwrite mappings later
  vim.b.did_bind_coc = true
  vim.b.did_bind_lsp = true

  map("n", "<Leader><Leader>", "<Plug>(coc-codeaction-cursor)", {
    desc = "coc.nvim code action",
    silent = true,
    buffer = opts.buf,
  })

  map("n", "gd", "<Plug>(coc-definition)", {
    desc = "Go To Definition",
    silent = true,
    buffer = opts.buf,
  })

  map("n", "<C-]>", "<Plug>(coc-definition)", {
    desc = "Go To Definition (tagfunc binding override)",
    silent = true,
    buffer = opts.buf,
  })

  -- ===========================================================================
  -- diagnostic jump -- using vim.diagnostic instead since we pipe coc into ALE
  -- ===========================================================================
  -- map(
  --   "n",
  --   "[d",
  --   "<Plug>(coc-diagnostic-prev)",
  --   { desc = "Go to prev diagnostic", buffer = opts.buf, silent = true }
  -- )
  -- map(
  --   "n",
  --   "]d",
  --   "<Plug>(coc-diagnostic-next)",
  --   { desc = "Go to next diagnostic", buffer = opts.buf, silent = true }
  -- )
end

-- =============================================================================
-- ts_ls
-- =============================================================================

-- on_attach binding for ts_ls
---@param client table
---@param bufnr integer
---@diagnostic disable-next-line: unused-local
M.bind_ts_ls_lsp = function(client, bufnr)
  -- Use TypeScript's Go To Source Definition so we don't end up in the
  -- type declaration files.
  map("n", "gd", function()
    -- typescript-tools.nvim
    if vim.fn.exists(":TSToolsGoToSourceDefinition") ~= 0 then
      vim.cmd.TSToolsGoToSourceDefinition()
      return
    end

    -- vtsls
    if vim.tbl_contains(require("dko.tools").get_mason_lsps(), "vtsls") then
      if
        require("dko.utils.typescript").go_to_source_definition(
          "vtsls",
          "typescript.goToSourceDefinition"
        )
      then
        return
      end

    -- ts_ls
    elseif
      require("dko.utils.typescript").go_to_source_definition(
        "ts_ls",
        "_typescript.goToSourceDefinition"
      )
    then
      return
    end

    -- fallback to telescope and default lsp definitions
    return telescope_builtin("lsp_definitions") or vim.lsp.buf.definition()
  end, {
    desc = "Go To Source Definition (typescript.nvim)",
    silent = true,
    buffer = bufnr,
  })

  -- For typescript only (i.e. not JSON files)
  -- use go to def for gf, lazy way of getting it to map import dir/ to
  -- dir/index.ts automatically
  if vim.startswith(vim.bo.filetype, "t") then
    map("n", "gf", "gd", { remap = true })
  end
end

-- ===========================================================================
-- Plugin: Comment.nvim
-- ===========================================================================

---@param tbl table
---@return table
M.with_commentnvim_mappings = function(tbl)
  ---LHS of operator-pending mappings in NORMAL and VISUAL mode
  tbl.opleader = {
    ---Line-comment keymap (default gc)
    line = "<Tab>",
    ---Block-comment keymap (gb is my blame command)
    block = "<Leader>b",
  }
  tbl.toggler = {
    ---Line-comment toggle keymap
    line = "<Tab><Tab>",
    ---Block-comment toggle keymap
    block = "<Leader>B",
  }
  return tbl
end

-- ===========================================================================
-- Plugin: cybu.nvim
-- ===========================================================================

M.cybu = {
  prev = "[b",
  next = "]b",
}
M.bind_cybu = function()
  map("n", M.cybu.prev, "<Plug>(CybuPrev)", {
    desc = "Previous buffer with cybu popup",
  })
  map("n", M.cybu.next, "<Plug>(CybuNext)", {
    desc = "Next buffer with cybu popup",
  })
end

-- ===========================================================================
-- Plugin: gitsigns.nvim
-- ===========================================================================

M.bind_gitsigns = function(bufnr)
  local function bufmap(mode, l, r, opts)
    opts = opts or {}
    opts.buffer = bufnr
    map(mode, l, r, opts)
  end

  -- Navigation
  bufmap("n", "]h", function()
    if vim.wo.diff then
      return "]h"
    end
    vim.schedule(function()
      require("gitsigns").next_hunk()
    end)
    return "<Ignore>"
  end, { expr = true, desc = "Next hunk" })

  bufmap("n", "[h", function()
    if vim.wo.diff then
      return "[h"
    end
    vim.schedule(function()
      require("gitsigns").prev_hunk()
    end)
    return "<Ignore>"
  end, { expr = true, desc = "Prev hunk" })

  -- Action
  bufmap("n", "gb", function()
    require("gitsigns").blame_line()
  end, { desc = "Popup blame for line" })
  bufmap("n", "gB", function()
    require("gitsigns").blame_line({ full = true })
  end, { desc = "Popul full blame for line" })

  -- Text object
  bufmap({ "o", "x" }, "ih", "<Cmd>Gitsigns select_hunk<CR>", {
    desc = "Select hunk",
  })
end

-- ===========================================================================
-- Plugin: inspecthi
-- ===========================================================================

M.bind_inspecthi = function()
  map("n", "zs", "<Cmd>Inspecthi<CR>", {
    desc = "Show highlight groups under cursor",
    silent = true,
  })
end

-- ===========================================================================
-- Plugin: nvim-cmp + cmp-snippy
-- ===========================================================================

M.bind_snippy = function()
  local snippy_ok, snippy = pcall(require, "snippy")
  if snippy_ok then
    local cmp = require("cmp")
    map({ "i", "s" }, "<C-b>", function()
      if snippy.can_jump(-1) then
        snippy.previous()
      end
      -- DO NOT FALLBACK (i.e. do not insert ^B)
    end, { desc = "snippy: previous field" })

    map({ "i", "s" }, "<C-f>", function()
      -- If a snippet is highlighted in PUM, expand it
      if cmp.confirm({ select = false }) then
        return
      end
      -- If in a snippet, jump to next field
      if snippy.can_expand_or_advance() then
        snippy.expand_or_advance()
        return
      end
    end, {
      desc = "snippy: expand or next field",
    })
  end
end

-- =============================================================================
-- Plugin: nvim-window
-- =============================================================================

M.bind_nvim_window = function()
  map("n", "<leader>w", function()
    require("nvim-window").pick()
  end, { desc = "nvim-window picker" })
end

-- ===========================================================================
-- Plugin: nvim-various-textobjs
-- ===========================================================================

M.bind_nvim_various_textobjs = function()
  -- Note: use <cmd> mapping format for dot-repeatability
  -- https://github.com/chrisgrieser/nvim-various-textobjs/commit/363dbb7#diff-b335630551682c19a781afebcf4d07bf978fb1f8ac04c6bf87428ed5106870f5R5

  local BLANKS = "noBlanks"

  map({ "o", "x" }, "ai", function()
    ---@type "inner"|"outer" exclude the startline
    local START = "outer"
    ---@type "inner"|"outer" exclude the endline
    local END = "outer"
    ---@type "withBlanks"|"noBlanks"
    require("various-textobjs").indentation(START, END, BLANKS)
    vim.cmd.normal("$") -- jump to end of line like vim-textobj-indent
  end, { desc = "textobj: indent" })

  map({ "o", "x" }, "ii", function()
    ---@type "inner"|"outer" exclude the startline
    local START = "inner"
    ---@type "inner"|"outer" exclude the endline
    local END = "inner"
    ---@type "withBlanks"|"noBlanks"
    require("various-textobjs").indentation(START, END, BLANKS)
    vim.cmd.normal("$") -- jump to end of line like vim-textobj-indent
  end, { desc = "textobj: indent" })

  map("n", "<Leader>s", function()
    if vim.fn.indent(".") == 0 then
      return "vapk:!sort<CR>"
    else
      return "vii:!sort<CR>"
    end
  end, {
    desc = "Auto select indent and sort",
    expr = true,
    remap = true, -- since ii is a mapping too
  })

  map(
    { "o", "x" },
    "ik",
    "<cmd>lua require('various-textobjs').key(true)<CR>",
    { desc = "textobj: object key" }
  )
  map(
    { "o", "x" },
    "iv",
    "<cmd>lua require('various-textobjs').value(true)<CR>",
    { desc = "textobj: object value" }
  )
  map(
    { "o", "x" },
    "is",
    "<cmd>lua require('various-textobjs').subword(true)<CR>",
    { desc = "textobj: camel-_Snake" }
  )

  --[[ map(
    { "o", "x" },
    "iu",
    "<cmd>lua require('various-textobjs').url()<CR>",
    { desc = "textobj: url" }
  ) ]]

  -- replaces netrw's gx
  map("n", "gx", function()
    -- -------------------------------------------------------------------------
    -- use lsplinks textDocument/documentLink if available
    -- -------------------------------------------------------------------------
    local lsplinks = require("lsplinks")
    local lsp_url = lsplinks.current()
    -- alternatively use vim.ui.open on lsplinks.current()
    if lsp_url then
      vim.print(("found lsp_url %s"):format(lsp_url))
      vim.ui.open(lsp_url)
      return
    end

    -- -------------------------------------------------------------------------
    -- otherwise find nearest url
    -- -------------------------------------------------------------------------
    require("various-textobjs").url() -- select URL
    -- this works since the plugin switched to visual mode
    -- if the textobj has been found
    local textobj_url = vim.fn.mode():find("v")
    if textobj_url then
      vim.print(("found textobj_url %s"):format(textobj_url))
      -- if not found in proximity, search whole buffer via urlview.nvim instead
      -- retrieve URL with the z-register as intermediary
      vim.cmd.normal({ '"zy', bang = true })
      local url = vim.fn.getreg("z", false) --[[@as string]]
      vim.ui.open(url)
      return
    end

    -- -------------------------------------------------------------------------
    -- Popup menu of all urls in buffer
    -- -------------------------------------------------------------------------
    vim.cmd.UrlView("buffer")
  end, { desc = "Smart URL Opener" })
end

-- ===========================================================================
-- Plugin: telescope.nvim
-- ===========================================================================

M.bind_telescope = function()
  local t = require("telescope")
  local tb = require("telescope.builtin")

  emap("n", "<A-e>", function()
    if t.extensions.file_browser then
      t.extensions.file_browser.file_browser({
        hidden = true, -- show hidden
      })
    end
  end, { desc = "Telescope: pick existing buffer" })

  emap("n", "<A-b>", function()
    tb.buffers({ layout_strategy = "vertical" })
  end, { desc = "Telescope: pick existing buffer" })

  emap("n", "<A-c>", function()
    tb.find_files({
      hidden = true,
      layout_strategy = "vertical",
    })
  end, { desc = "Telescope: files in cwd" })

  emap("n", "<A-f>", function()
    -- https://github.com/nvim-telescope/telescope.nvim/wiki/Configuration-Recipes#falling-back-to-find_files-if-git_files-cant-find-a-git-directory
    local res =
      vim.system({ "git", "rev-parse", "--is-inside-work-tree" }):wait()
    if res.code == 0 then
      tb.git_files({
        layout_strategy = "vertical",
        show_untracked = true,
      })
    else
      tb.find_files({
        hidden = true,
        layout_strategy = "vertical",
      })
    end
  end, { desc = "Telescope: files in git work files or CWD" })

  emap("n", "<A-g>", function()
    tb.live_grep({ layout_strategy = "vertical" })
  end, { desc = "Telescope: live grep CWD" })

  emap("n", "<A-m>", function()
    tb.oldfiles({ layout_strategy = "vertical" })
  end, { desc = "Telescope: pick from previously opened files" })

  emap("n", "<A-p>", function()
    tb.find_files({
      hidden = true,
      layout_strategy = "vertical",
      prompt_title = "Files in buffer's project",
      cwd = require("dko.utils.project").root(),
    })
  end, {
    desc = "Telescope: pick from previously opened files in current project root",
  })

  emap("n", "<A-r>", function()
    tb.resume()
  end, { desc = "Telescope: re-open last picker" })

  emap("n", "<A-s>", function()
    tb.git_status({ layout_strategy = "vertical" })
  end, { desc = "Telescope: pick from git status files" })

  emap("n", "<A-t>", function()
    tb.find_files({
      layout_strategy = "vertical",
      prompt_title = "Find tests",
      search_dirs = {
        "./test/",
        "./tests/",
        "./spec/",
        "./specs/",
      },
    })
  end, { desc = "Telescope: pick files in CWD" })

  emap("n", "<A-v>", function()
    tb.find_files({
      layout_strategy = "vertical",
      prompt_title = "Find in neovim configs",
      cwd = vim.fn.stdpath("config"),
      hidden = true,
    })
  end, { desc = "Telescope: nvim/ files" })

  emap("n", "<A-y>", function()
    if not t.extensions.yank_history then
      t.load_extension("yank_history")
    end
    t.extensions.yank_history.yank_history()
  end, { desc = "Telescope: yanky.nvim" })
end

-- ===========================================================================
-- Plugin: textobjs
-- ===========================================================================

M.bind_textobj = function()
  local function textobjMap(obj, char)
    char = char or obj:sub(1, 1)
    map(
      { "o", "x" },
      "a" .. char,
      "<Plug>(textobj-" .. obj .. "-a)",
      { desc = "textobj: around " .. obj }
    )
    map(
      { "o", "x" },
      "i" .. char,
      "<Plug>(textobj-" .. obj .. "-i)",
      { desc = "textobj: inside " .. obj }
    )
  end

  textobjMap("paste", "P")
  textobjMap("url")
end

-- ===========================================================================
-- Plugin: toggleterm.nvim
-- ===========================================================================

local common_winbar = {
  enabled = true,
  ---@diagnostic disable-next-line: unused-local
  name_formatter = function(term)
    return "<A-x>"
  end,
}

local toggleterm_modes = {
  horizontal = {
    keybind = "<A-i>",
    count = 88888,
    name = "common",
    winbar = common_winbar,
  },
  vertical = {
    keybind = "<A-C-i>",
    count = 88888,
    name = "common",
    sizefn = function()
      return math.max(vim.o.columns * 0.4, 20)
    end,
    winbar = common_winbar,
  },
  float = {
    keybind = "<A-S-i>",
    count = 99999,
    name = "floating",
  },
}

M.toggleterm_all_keys = {
  toggleterm_modes.horizontal.keybind,
  toggleterm_modes.vertical.keybind,
  toggleterm_modes.float.keybind,
}

M.bind_toggleterm = function()
  local original
  local terms = {}
  for mode, settings in pairs(toggleterm_modes) do
    -- in ANY terminal, if you press ANY toggleterm keybind, term will close
    -- and refocus prev win if possible
    map("t", settings.keybind, function()
      vim.cmd.close()
      -- on_close fires
    end, { desc = "Close terminal and restore focus" })

    -- =======================================================================

    terms[settings.name] = terms[settings.name]
      or require("toggleterm.terminal").Terminal:new({
        count = settings.count,
        direction = mode,
        display_name = "", -- using winbar for name
        on_close = vim.schedule_wrap(function()
          if original then
            vim.api.nvim_set_current_win(original)
            original = nil
          end
          vim.cmd.doautocmd("WinLeave")
        end),
        winbar = settings.winbar,
      })
    map("n", settings.keybind, function()
      if vim.bo.buftype ~= "terminal" then
        original = vim.api.nvim_get_current_win()
      end
      local size = settings.sizefn and settings.sizefn() or 15
      terms[settings.name]:toggle(size, mode)
    end, { desc = "Open a " .. mode .. " terminal" })
  end
end

-- ===========================================================================
-- Plugin: treesj
-- ===========================================================================

M.treesj = "gs"
M.bind_treesj = function()
  map("n", M.treesj, function()
    require("treesj").toggle()
  end, { desc = "Toggle treesitter split / join", silent = true })
end

-- ===========================================================================
-- Plugin: tw-values.nvim
-- ===========================================================================

M.twvalues = "<leader>tw"
M.bind_twvalues = function()
  map("n", M.twvalues, "<Cmd>TWValues<CR>", {
    desc = "Show tailwind CSS values",
  })
end

-- ===========================================================================
-- Plugin: urlview.nvim
-- ===========================================================================

M.urlview = {
  prev = "[u",
  next = "]u",
}

M.bind_urlview = function()
  require("urlview").setup({
    jump = {
      prev = M.urlview.prev,
      next = M.urlview.next,
    },
  })
  map("n", "<A-u>", "<Cmd>UrlView<CR>", { desc = "Open URLs" })
end

-- ===========================================================================
-- Plugin: yanky.nvim
-- ===========================================================================

M.bind_yanky = function()
  map({ "n", "x" }, "p", "<Plug>(YankyPutAfter)", { desc = "yanky put after" })
  map(
    { "n", "x" },
    "P",
    "<Plug>(YankyPutBefore)",
    { desc = "yanky put before" }
  )
  map(
    { "n", "x" },
    "gp",
    "<Plug>(YankyGPutAfter)",
    { desc = "yanky gput after" }
  )
  map(
    { "n", "x" },
    "gP",
    "<Plug>(YankyGPutBefore)",
    { desc = "yanky gput before" }
  )
  map(
    "n",
    "<c-n>",
    "<Plug>(YankyPreviousEntry)",
    { desc = "yanky previous entry" }
  )
  map(
    "n",
    "<c-p>",
    "<Plug>(YankyNextEntry)",
    { desc = "yanky next entry backward" }
  )
end

-- ===========================================================================
-- Plugin: zoomwintab.vim
-- ===========================================================================

M.zoomwintab = {
  "<C-w>o",
  "<C-w><C-o>",
}

-- ===========================================================================

return M
