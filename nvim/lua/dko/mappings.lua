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
-- Diagnostic mappings
-- ===========================================================================

local goto_opts = {
  noremap = true,
  silent = true,
  desc = "Go to diagnostic and open float",
}
local float_opts = {
  focus = false,
  scope = "cursor",
}
map("n", "[d", function()
  vim.diagnostic.goto_prev({ float = float_opts })
end, goto_opts)
map("n", "]d", function()
  vim.diagnostic.goto_next({ float = float_opts })
end, goto_opts)
map("n", "<Leader>d", function()
  vim.diagnostic.open_float(float_opts)
end, { desc = "Open diagnostic float at cursor" })
