local command = vim.api.nvim_create_user_command

local Methods = vim.lsp.protocol.Methods

-- ===========================================================================
-- Command aliases
-- ===========================================================================

vim.cmd.cabbrev("Wq", "wq")
vim.cmd.cabbrev("Q", "q")
vim.cmd.cabbrev("Qa", "qa")

-- ===========================================================================
-- External interaction
-- ===========================================================================

-- This is a command run by ~/.dotfiles/bin/e before sending events to
-- existing server (e.g. --remote-send files to edit)
command("DKOExternal", function()
  require("dko.utils.ui").close_floats()
  local is_toggleterm = vim.api.nvim_buf_get_name(0):find("#toggleterm")
  if is_toggleterm then
    vim.cmd.close()
  end
end, { desc = "Prepare to receive an external command" })

command(
  "DKOLight",
  require("dko.colors").lightmode,
  { desc = "Set light colorscheme" }
)

command(
  "DKODark",
  require("dko.colors").darkmode,
  { desc = "Set dark colorscheme" }
)

-- ===========================================================================
-- File ops
-- ===========================================================================

command("Delete", function()
  local fp = vim.api.nvim_buf_get_name(0)

  ---@TODO consider vim.fs.rm
  local ok, err = vim.uv.fs_unlink(fp)
  if not ok then
    vim.notify(
      table.concat({ fp, err }, "\n"),
      vim.log.levels.ERROR,
      { title = ":Delete failed" }
    )
    vim.cmd.bwipeout()
  else
    require("dko.utils.buffer").close()
    vim.notify(fp, vim.log.levels.INFO, { title = ":Delete succeeded" })
  end
end, { desc = "Delete current file" })

command("Rename", function(opts)
  if vim.b.did_bind_coc then
    vim.cmd.CocCommand("workspace.renameCurrentFile")
    return
  end

  local prevpath = vim.fn.expand("%:p")
  local prevname = vim.fn.expand("%:t")
  local prevdir = vim.fn.expand("%:p:h")
  vim.ui.input({
    prompt = "New file name: ",
    default = opts.fargs[1] or prevname,
    completion = "file",
  }, function(next)
    if not next or next == "" or next == prevname then
      return
    end
    local nextpath = ("%s/%s"):format(prevdir, next)

    local changes, clients
    if type(prevpath) == "string" then
      clients = vim.lsp.get_clients()
      changes = {
        files = {
          {
            oldUri = vim.uri_from_fname(prevpath),
            newUri = vim.uri_from_fname(nextpath),
          },
        },
      }

      for _, client in ipairs(clients) do
        if client:supports_method(Methods.workspace_willRenameFiles) then
          local resp = client:request_sync(
            Methods.workspace_willRenameFiles,
            changes,
            1000,
            0
          )
          if resp and resp.result ~= nil then
            vim.lsp.util.apply_workspace_edit(
              resp.result,
              client.offset_encoding
            )
          end
        end
      end
    end

    vim.cmd.file(nextpath) -- rename buffer, preserving undo
    vim.cmd("noautocmd write") -- save
    vim.cmd("edit") -- update file syntax if you changed extension

    if changes ~= nil and #clients > 0 and type(prevpath) == "string" then
      for _, client in ipairs(clients) do
        if client:supports_method(Methods.workspace_didRenameFiles) then
          client:notify(Methods.workspace_didRenameFiles, changes)
        end
      end
    else
      return
    end

    ---@TODO consider vim.fs.rm
    local ok, err = vim.uv.fs_unlink(prevpath)
    if not ok then
      vim.notify(
        table.concat({ prevpath, err }, "\n"),
        vim.log.levels.ERROR,
        { title = ":Rename failed to delete orig" }
      )
    end
  end)
end, {
  desc = "Rename current file",
  nargs = "?",
  complete = function()
    return { vim.fn.expand("%") }
  end,
})

-- =============================================================================
-- Git
-- =============================================================================

command("Gitbrowse", function()
  local gbok, gb = pcall(require, "snacks.gitbrowse")
  if not gbok then
    return
  end
  gb.open()
end, { desc = "Open branch, file, line in origin git site" })

command("Gitbranch", function()
  local gbok, gb = pcall(require, "snacks.gitbrowse")
  if not gbok then
    return
  end
  gb.open({ what = "branch" })
end, { desc = "Open branch in origin git site" })

command("Gitrepo", function()
  local gbok, gb = pcall(require, "snacks.gitbrowse")
  if not gbok then
    return
  end
  gb.open({ what = "repo" })
end, { desc = "Open repo root in origin git site" })

-- ===========================================================================
-- VTSLS
-- ===========================================================================

---@see vscode docs <https://github.com/microsoft/vscode/blob/570f7da3b52bde576d6bba5f71cb44ddda1460a8/extensions/typescript-language-features/src/languageFeatures/fileConfigurationManager.ts#L309-L316>
---@enum importModuleSpecifier
local import_module_specifiers = {
  "relative",
  "non-relative",
  "project-relative",
}

command("ChangeImportModuleSpecifier", function()
  local clients = vim.lsp.get_clients({ name = "vtsls" })
  if #clients == 0 then
    require("dko.utils.notify").toast(
      "vtsls not attached",
      vim.log.levels.ERROR,
      { group = "typescript", render = "wrapped-compact" }
    )
    return
  end
  local client = clients[1]
  local prefs = client.config.settings.typescript.preferences --[[@as table]]
  local current = prefs.importModuleSpecifier --[[@as importModuleSpecifier]]
  local current_index =
    require("dko.utils.table").index(import_module_specifiers, current)
  local next_index = current_index + 1
  if next_index > #import_module_specifiers then
    next_index = 1
  end
  local next = import_module_specifiers[next_index]
  local success = require("dko.lsp").change_client_settings(client, {
    typescript = {
      preferences = { importModuleSpecifier = next },
    },
  })
  if success then
    require("dko.utils.notify").toast(
      ("Changed importModuleSpecifier to %s"):format(next),
      vim.log.levels.INFO,
      { group = "typescript", render = "wrapped-compact" }
    )
  end
end, { desc = "Cycle through importModuleSpecifier" })
