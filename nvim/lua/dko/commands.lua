local command = vim.api.nvim_create_user_command

local Methods = vim.lsp.protocol.Methods

-- ===========================================================================
-- Command aliases
-- ===========================================================================

command("Q", "q", { bang = true, desc = ":Q same as :q" })

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
        if client.supports_method(Methods.workspace_willRenameFiles) then
          local resp = client.request_sync(
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

    if changes ~= nil and #clients and type(prevpath) == "string" then
      for _, client in ipairs(clients) do
        if client.supports_method(Methods.workspace_didRenameFiles) then
          client.notify(Methods.workspace_didRenameFiles, changes)
        end
      end
    else
      return
    end

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
