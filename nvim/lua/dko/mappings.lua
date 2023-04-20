local M = {}

local map = vim.keymap.set

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

map(
  "n",
  "<BS>",
  "<C-^>",
  { desc = "Prev buffer with <BS> backspace in normal (C-^ is kinda awkward)" }
)

local resizeOpts =
  { desc = "Resize window with Shift+DIR, can take a count #<S-Dir>" }
map("n", "<S-Up>", "<C-W>+", resizeOpts)
map("n", "<S-Down>", "<C-W>-", resizeOpts)
map("n", "<S-Left>", "<C-w><", resizeOpts)
map("n", "<S-Right>", "<C-w>>", resizeOpts)

map("n", "<Leader>x", function()
  require("dko.utils.buffer").close()
end, { desc = "Remove buffer (try without closing window)" })

map("n", "<Leader>l", function()
  require('dko.utils.loclist').toggle()
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
  local root = require("dko.project").git_root()
  if root then
    if vim.loop.chdir(root) == 0 then
      vim.notify(root, vim.log.levels.INFO, { title = "Changed directory" })
    end
  end
end, { desc = "cd to current buffer's git root" })

-- ===========================================================================
-- :edit shortcuts
-- ===========================================================================

map("n", "<Leader>ecr", function()
  require("dko.utils.edit_closest")("README.md")
end, { desc = "Edit closest README.md" })

map("n", "<Leader>epj", function()
  require("dko.utils.edit_closest")("package.json")
end, { desc = "Edit closest package.json" })

map("n", "<Leader>evi", function()
  vim.cmd.edit(vim.fn.stdpath("config") .. "/init.lua")
end, { desc = "Edit init.lua" })

map("n", "<Leader>evm", function()
  vim.cmd.edit(vim.fn.stdpath("config") .. "/lua/dko/mappings.lua")
end, { desc = "Edit mappings.lua" })

map("n", "<Leader>evp", function()
  vim.cmd.edit(vim.fn.stdpath("config") .. "/lua/dko/plugins/")
end, { desc = "Edit lua/dko/plugins/" })

-- ===========================================================================
-- Buffer: Reading
-- ===========================================================================

map({ "i", "n" }, "<F1>", "<NOP>", { desc = "Disable help shortcut key" })

map("n", "<F1>", function()
  local h = require("dko.utils.help")
  local res = h.find(vim.fn.expand("<cexpr>"))
  vim.print(res)
  if res then
    vim.cmd.help(res.match)
  end
end, { desc = "Show vim help for <cexpr>" })

map("n", "<Leader>yn", function()
  local res = vim.fn.expand("%:t")
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
  local res = vim.fn.expand("%:p")
  res = res == "" and vim.loop.cwd() or res
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
  end, { desc = "Append horizontal rule of " .. v .. " up to &textwidth" })
end

map("x", "<Leader>C", function()
  -- @TODO replace with https://github.com/neovim/neovim/pull/13896
  vim.api.nvim_feedkeys("y", "nx", false)
  local selection = vim.fn.getreg('"')
  local converted = require("dko.utils.string").smallcaps(selection)
  vim.fn.setreg('"', converted)
  vim.api.nvim_feedkeys('gv""P', "nx", false)
end, { desc = "Convert selection to smallcaps" })

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
  local current_line = require("dko.utils.buffer").get_cursorline_contents()
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

map("n", "[d", function()
  vim.diagnostic.goto_prev({})
end, { desc = "Go to prev diagnostic and open float" })
map("n", "]d", function()
  vim.diagnostic.goto_next({})
end, { desc = "Go to next diagnostic and open float" })
map("n", "<Leader>d", function()
  vim.diagnostic.open_float()
end, { desc = "Open diagnostic float at cursor" })

-- ===========================================================================
-- Treesitter utils
-- ===========================================================================

map("n", "ss", function()
  vim.print(vim.treesitter.get_captures_at_cursor())
end, { desc = "Print treesitter captures under cursor" })

map("n", "sy", function()
  local captures = vim.treesitter.get_captures_at_cursor()
  local parsedCaptures = {}
  for _, capture in ipairs(captures) do
    table.insert(parsedCaptures, "@" .. capture)
  end
  if #parsedCaptures == 0 then
    vim.notify(
      "No treesitter captures under cursor",
      vim.log.levels.ERROR,
      { title = "Yank failed", render = "compact" }
    )
    return
  end
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
---@return boolean whether or not telescope was succesfully called
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

-- LspAttach autocmd callback
---@param bufnr number
M.bind_lsp = function(bufnr)
  ---@param opts table
  ---@return table opts with silent and buffer set
  local function lsp_opts(opts)
    opts.silent = true
    opts.buffer = bufnr
    return opts
  end

  map(
    "n",
    "gD",
    vim.lsp.buf.declaration,
    lsp_opts({ desc = "LSP declaration" })
  )
  map("n", "gd", function()
    return telescope_builtin("lsp_definitions") or vim.lsp.buf.definition()
  end, lsp_opts({ desc = "LSP definition" }))
  map("n", "K", vim.lsp.buf.hover, lsp_opts({ desc = "LSP hover" }))

  map("n", "gi", function()
    return telescope_builtin("lsp_implementations")
      or vim.lsp.buf.implementation()
  end, lsp_opts({ desc = "LSP implementation" }))
  map(
    { "n", "i" },
    "<C-g>",
    vim.lsp.buf.signature_help,
    lsp_opts({ desc = "LSP signature_help" })
  )
  --map('n', '<space>wa', vim.lsp.buf.add_workspace_folder, bufopts)
  --map('n', '<space>wr', vim.lsp.buf.remove_workspace_folder, bufopts)
  --[[ map('n', '<space>wl', function()
    print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
  end, bufopts) ]]
  map("n", "<Leader>D", function()
    return telescope_builtin("lsp_type_definitions")
      or vim.lsp.buf.type_definition()
  end, lsp_opts({ desc = "LSP type_definition" }))
  map("n", "<Leader>rn", vim.lsp.buf.rename, lsp_opts({ desc = "LSP rename" }))
  map(
    "n",
    "<Leader>ca",
    vim.lsp.buf.code_action,
    lsp_opts({ desc = "LSP Code Action" })
  )
  map("n", "<Leader><Leader>", require("dko.lsp").code_action)

  map("n", "gr", function()
    return telescope_builtin("lsp_references")
      ---@diagnostic disable-next-line: missing-parameter
      or vim.lsp.buf.references()
  end, lsp_opts({ desc = "LSP references" }))

  map("n", "<A-=>", function()
    require("dko.lsp").format({ async = false })
  end, lsp_opts({ desc = "Fix and format buffer with dko.lsp.format_buffer" }))
end

-- on_attach binding for tsserver
M.bind_tsserver_lsp = function(bufnr)
  -- Use TypeScript's Go To Source Definition so we don't end up in the
  -- type declaration files.
  map("n", "gd", function()
    if require("dko.typescript").source_definition() then
      return
    end
    return telescope_builtin("lsp_definitions") or vim.lsp.buf.definition()
  end, {
    desc = "Go To Source Definition (typescript.nvim)",
    silent = true,
    buffer = bufnr,
  })
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
    line = "gc",
    ---Block-comment keymap (gb is my blame command)
    block = "gb",
  }
  tbl.toggler = {
    ---Line-comment toggle keymap
    line = "gcc",
    ---Block-comment toggle keymap
    block = "gbb",
  }
  return tbl
end

-- ===========================================================================
-- Plugin: cybu.nvim
-- ===========================================================================

M.bind_cybu = function()
  map("n", "[b", "<Plug>(CybuPrev)", {
    desc = "Previous buffer with cybu popup",
  })
  map("n", "]b", "<Plug>(CybuNext)", { desc = "Next buffer with cybu popup" })
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

  -- Actions
  -- the ones that use <Cmd> take a range, don't pass as gs.method
  bufmap(
    { "n", "v" },
    "<leader>hr",
    "<Cmd>Gitsigns reset_hunk",
    { desc = "Reset hunk" }
  )
  bufmap(
    "n",
    "<leader>hp",
    require("gitsigns").preview_hunk,
    { desc = "Preview hunk" }
  )
  bufmap("n", "<Leader>gb", function()
    require("gitsigns").blame_line({ full = true })
  end, { desc = "Show blames" })

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
-- Plugin: nvim-cmp
-- ===========================================================================

---@return table used in cmp.setup({})
M.setup_cmp = function()
  local snippy_ok, snippy = pcall(require, "snippy")
  local cmp = require("cmp")

  map("n", "<C-Space>", function()
    vim.cmd.startinsert({ bang = true })
    vim.schedule(cmp.complete)
  end, { desc = "In normal mode, `A`ppend and start completion" })

  local snippy_mappings = snippy_ok
      and {
        -- snippy: previous field
        ["<C-b>"] = cmp.mapping(function()
          if snippy.can_jump(-1) then
            snippy.previous()
          end
          -- DO NOT FALLBACK (i.e. do not insert ^B)
        end, { "i", "s" }),

        -- snippy: expand or next field
        ["<C-f>"] = cmp.mapping(function(fallback)
          -- If a snippet is highlighted in PUM, expand it
          if cmp.confirm({ select = false }) then
            return
          end
          -- If in a snippet, jump to next field
          if snippy.can_expand_or_advance() then
            snippy.expand_or_advance()
            return
          end
          fallback()
        end, { "i", "s" }),
      }
    or {}

  return cmp.mapping.preset.insert(vim.tbl_extend("force", {
    ["<C-k>"] = cmp.mapping.scroll_docs(-4),
    ["<C-j>"] = cmp.mapping.scroll_docs(4),
    ["<C-Space>"] = cmp.mapping.complete(),
  }, snippy_mappings))
end

-- ===========================================================================
-- Plugin: nvim-notify
-- ===========================================================================

M.bind_notify = function()
  map(
    "n",
    "<A-\\>",
    "<Cmd>Notifications<CR>",
    { desc = "Show recent notifications" }
  )
end

-- ===========================================================================
-- Plugin: nvim-various-textobjs
-- ===========================================================================

M.bind_nvim_various_textobjs = function()
  -- Note: use <cmd> mapping format for dot-repeatability
  -- https://github.com/chrisgrieser/nvim-various-textobjs/commit/363dbb7#diff-b335630551682c19a781afebcf4d07bf978fb1f8ac04c6bf87428ed5106870f5R5

  -- map({ "o", "x" }, "ii", function()
  --   require("various-textobjs").indentation(true, true)
  --   vim.cmd.normal("$") -- jump to end of line like vim-textobj-indent
  -- end, { desc = "textobj: indent" })

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
    require("various-textobjs").url() -- select URL
    -- this works since the plugin switched to visual mode
    -- if the textobj has been found
    local foundURL = vim.fn.mode():find("v")
    -- if not found in proximity, search whole buffer via urlview.nvim instead
    if not foundURL then
      vim.cmd.UrlView("buffer")
      return
    end

    -- retrieve URL with the z-register as intermediary
    vim.cmd.normal({ '"zy', bang = true })
    local url = vim.fn.getreg("z")
    -- open with the OS-specific shell command
    local opener
    if vim.fn.has("macunix") == 1 then
      opener = "open"
    elseif vim.fn.has("linux") == 1 then
      opener = "xdg-open"
    elseif vim.fn.has("win64") == 1 or vim.fn.has("win32") == 1 then
      opener = "start"
    end
    local openCommand = string.format("%s '%s' >/dev/null 2>&1", opener, url)
    os.execute(openCommand)
  end, { desc = "Smart URL Opener" })
end

-- ===========================================================================
-- Plugin: telescope.nvim
-- ===========================================================================

M.bind_telescope = function()
  local t = require("telescope")

  map("n", "<A-e>", function()
    if t.extensions.file_browser then
      t.extensions.file_browser.file_browser({
        hidden = true, -- show hidden
      })
    end
  end, { desc = "Telescope: pick existing buffer" })

  map("n", "<A-b>", function()
    require("telescope.builtin").buffers({ layout_strategy = "vertical" })
  end, { desc = "Telescope: pick existing buffer" })

  map("n", "<A-f>", function()
    -- https://github.com/nvim-telescope/telescope.nvim/wiki/Configuration-Recipes#falling-back-to-find_files-if-git_files-cant-find-a-git-directory
    vim.fn.system("git rev-parse --is-inside-work-tree")
    local finder = vim.v.shell_error == 0
        and require("telescope.builtin").git_files
      or require("telescope.builtin").find_files
    finder({ layout_strategy = "vertical" })
  end, { desc = "Telescope: pick files in CWD" })

  map("n", "<A-g>", function()
    require("telescope.builtin").live_grep({ layout_strategy = "vertical" })
  end, { desc = "Telescope: live grep CWD" })

  map("n", "<A-m>", function()
    require("telescope.builtin").oldfiles({ layout_strategy = "vertical" })
  end, { desc = "Telescope: pick from previously opened files" })

  map("n", "<A-p>", function()
    local project_root = vim.fn["dko#project#GetRoot"]()

    -- fallback to cwd git root
    if not project_root or project_root:len() == 0 then
      project_root = vim.fn["dko#git#GetRoot"](vim.fn.getcwd())
    end

    if not project_root or project_root:len() == 0 then
      vim.notify("Not in a project", vim.log.levels.ERROR, { title = "<A-p>" })
      return
    end

    require("telescope.builtin").find_files({
      layout_strategy = "vertical",
      prompt_title = "Files in " .. project_root,
      cwd = project_root,
    })
  end, {
    desc = "Telescope: pick from previously opened files in current project root",
  })

  map("n", "<A-s>", function()
    require("telescope.builtin").git_status({ layout_strategy = "vertical" })
  end, { desc = "Telescope: pick from git status files" })

  map("n", "<A-t>", function()
    require("telescope.builtin").find_files({
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

  map("n", "<A-v>", function()
    require("telescope.builtin").find_files({
      layout_strategy = "vertical",
      prompt_title = "Find in neovim configs",
      cwd = vim.fn.stdpath("config"),
      hidden = true,
    })
  end, { desc = "Telescope: pick from vim config files" })
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

  textobjMap("indent")
  map("n", "<Leader>s", "vii:!sort<CR>", {
    desc = "Auto select indent and sort",
    remap = true, -- since ii is a mapping too
  })

  textobjMap("paste", "P")
  textobjMap("url")
end

-- ===========================================================================
-- Plugin: toggleterm.nvim
-- ===========================================================================

M.toggleterm = {
  horizontal = "<A-i>",
  float = "<C-i>",
}

M.bind_toggleterm = function()
  local horizontal = require("toggleterm.terminal").Terminal:new({
    count = 88888,
    direction = "horizontal",
    on_open = function()
      vim.keymap.set(
        "t",
        M.toggleterm.horizontal,
        "<Cmd>close<CR>",
        { buffer = true, noremap = true, silent = true }
      )
    end,
  })
  map("n", M.toggleterm.horizontal, function()
    horizontal:toggle()
  end, {
    desc = "Open a horizontal floating terminal",
  })

  local floating = require("toggleterm.terminal").Terminal:new({
    count = 99999,
    direction = "float",
    on_open = function()
      vim.keymap.set(
        "t",
        M.toggleterm.float,
        "<Cmd>close<CR>",
        { buffer = true, noremap = true, silent = true }
      )
    end,
  })
  map("n", M.toggleterm.float, function()
    floating:toggle()
  end, {
    desc = "Open a big floating terminal",
  })
end

-- ===========================================================================
-- Plugin: treesj
-- ===========================================================================

M.bind_treesj = function()
  map("n", "gs", function()
    require("treesj").toggle()
  end, { desc = "Toggle treesitter split / join", silent = true })
end

-- ===========================================================================
-- Plugin: urlview.nvim
-- ===========================================================================

M.bind_urlview = function()
  require("urlview").setup({
    jump = {
      prev = "[u",
      next = "]u",
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
    "<Plug>(YankyCycleForward)",
    { desc = "yanky cycle forward" }
  )
  map(
    "n",
    "<c-p>",
    "<Plug>(YankyCycleBackward)",
    { desc = "yanky cycle backward" }
  )
end

-- ===========================================================================

return M
