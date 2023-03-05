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

-- ===========================================================================
-- Switch mode
-- ===========================================================================

local leaderLeaderOpts = {
  desc = "Toggle visual/normal mode with space-space",
}
map("n", "<Leader><Leader>", "V", leaderLeaderOpts)
map("x", "<Leader><Leader>", "<Esc>", leaderLeaderOpts)

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
  vim.fn.chdir(vim.fn["dko#project#GetRoot"]())
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
map(
  "n",
  "<Leader>evi",
  "<Cmd>edit " .. vim.fn.stdpath("config") .. "/init.lua<CR>",
  { desc = "Edit init.lua" }
)
map(
  "n",
  "<Leader>evm",
  "<Cmd>edit " .. vim.fn.stdpath("config") .. "/lua/dko/mappings.lua<CR>",
  { desc = "Edit mappings.lua" }
)
map(
  "n",
  "<Leader>evp",
  "<Cmd>edit " .. vim.fn.stdpath("config") .. "/lua/dko/plugins/<CR>",
  { desc = "Edit lua/dko/plugins/" }
)

-- ===========================================================================
-- Buffer: Reading
-- ===========================================================================

map({ "i", "n" }, "<F1>", "<NOP>", { desc = "Disable help shortcut key" })

map(
  "n",
  "<F1>",
  require("dko.utils.help"),
  { desc = "Show vim help for <cexpr>" }
)

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
  if res == "" then
    res = vim.fn.getcwd()
  end
  vim.fn.setreg("+", res)
  vim.notify(res, vim.log.levels.INFO, { title = "Yanked filepath" })
end, { desc = "Yank the full filepath of current buffer" })

-- ===========================================================================
-- Buffer: Movement
-- ===========================================================================

map(
  "n",
  "<Leader>mm",
  require("dko.utils.movemode").toggle,
  { desc = "Toggle move mode" }
)

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

map("n", "<Leader>ws", function()
  vim.fn["dko#whitespace#clean"]()
end, { desc = "Remove trailing whitespace from entire file" })

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
  if string.match(current_line, all_spaces_regex) then
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
  return string.rep(" ", 1 + sts - spaces_from_cursor_to_next_sts)
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

local settings = require("dko.settings")

local function assert_highlighting_enabled()
  if not settings.get("treesitter.highlight_enabled") then
    vim.notify(
      "Treesitter highlight is disabled",
      vim.log.levels.WARN,
      { render = "compact" }
    )
    return false
  end
  return true
end

map("n", "ss", function()
  if not assert_highlighting_enabled() then
    return
  end

  vim.pretty_print(vim.treesitter.get_captures_at_cursor())
end, { desc = "Print treesitter captures under cursor" })

map("n", "sy", function()
  if not assert_highlighting_enabled() then
    return
  end

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

M.bind_lsp = function()
  local function lsp_opts(opts)
    opts = vim.tbl_extend("force", {
      silent = true,
      buffer = true,
    }, opts)
  end

  local function with_telescope(method)
    local ok, telescope = pcall(require, "telescope.builtin")
    return ok and telescope[method]() or nil
  end

  local handlers = {
    definition = function()
      return with_telescope("lsp_definitions") or vim.lsp.buf.definition
    end,
    references = function()
      return with_telescope("lsp_references") or vim.lsp.buf.references
    end,
    implementation = function()
      return with_telescope("lsp_implementations") or vim.lsp.buf.implementation
    end,
    type_definition = function()
      return with_telescope("lsp_type_definitions")
        or vim.lsp.buf.type_definition
    end,
  }

  map(
    "n",
    "gD",
    vim.lsp.buf.declaration,
    lsp_opts({ desc = "LSP declaration" })
  )
  map("n", "gd", handlers.definition, lsp_opts({ desc = "LSP definition" }))
  map("n", "K", vim.lsp.buf.hover, lsp_opts({ desc = "LSP hover" }))

  map(
    "n",
    "gi",
    handlers.implementation,
    lsp_opts({ desc = "LSP implementation" })
  )
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
  map(
    "n",
    "<Leader>D",
    handlers.type_definition,
    lsp_opts({ desc = "LSP type_definition" })
  )
  map("n", "<Leader>rn", vim.lsp.buf.rename, lsp_opts({ desc = "LSP rename" }))
  map(
    "n",
    "<Leader>ca",
    vim.lsp.buf.code_action,
    lsp_opts({ desc = "LSP Code Action" })
  )

  map("n", "gr", handlers.references, lsp_opts({ desc = "LSP references" }))

  map("n", "<A-=>", function()
    require("dko.lsp").format({ async = false })
  end, lsp_opts({ desc = "Fix and format buffer with dko.lsp.format_buffer" }))
end

return M
