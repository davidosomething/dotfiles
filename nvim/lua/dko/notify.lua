local dkostring = require("dko.utils.string")

-- =====================================================================
-- Override vim.notify builtin
-- known special titles
-- mason ones should not go to fidget because mason window will cover it
-- - "mason.nvim"
-- - "mason-lspconfig.nvim"
-- - "nvim-treesitter"
-- =====================================================================

---@param msg string
---@param level? number vim.log.levels.*
---@param opts? table
local override = function(msg, level, opts)
  opts = opts or {}

  if opts.title == "package-info.nvim" then
    return
  end

  if opts.title == "nvim-treesitter" then
    local fok, fidget = pcall(require, "fidget")
    if fok then
      fidget.notify(msg, level, opts)
    else
      vim.print(msg)
    end
    return
  end

  if not opts.title then
    if dkostring.starts_with(msg, "[LSP]") then
      local client, found_client = msg:gsub("^%[LSP%]%[(.-)%] .*", "%1")
      if found_client > 0 then
        opts.title = ("[LSP] %s"):format(client)
      else
        opts.title = "[LSP]"
      end
      msg = msg:gsub("^%[.*%] (.*)", "%1")
    elseif msg == "No code actions available" then
      -- https://github.com/neovim/neovim/blob/master/runtime/lua/vim/lsp/buf.lua#LL629C39-L629C39
      opts.title = "[LSP]"
    end
  end

  local nok, notify = pcall(require, "notify")
  if nok then
    if opts.title and dkostring.starts_with(opts.title, "[LSP]") then
      opts.render = "wrapped-compact"
    end
    notify(msg, level, opts)
    return
  end

  vim.print(("%s: %s"):format(opts.title, msg))
end
vim.notify = override
