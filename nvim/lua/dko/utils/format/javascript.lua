local dkosettings = require("dko.settings")
local dkonode = require("dko.utils.node")

local function format_with_coc(notify)
  local eslint_only = vim.b.has_eslint_plugin_prettier
  notify(
    eslint_only and { "coc-eslint with eslint-plugin-prettier" }
      or { "coc-eslint" }
  )
  vim.cmd.call("CocAction('runCommand', 'eslint.executeAutofix')")
  vim.cmd.sleep(eslint_only and "100m" or "1m")
end

local function format_with_lsp(notify)
  local eslint_only = vim.b.has_eslint_plugin_prettier
  if #vim.lsp.get_clients({ bufnr = 0, name = "eslint" }) > 0 then
    vim.cmd.EslintFixAll()
    notify(eslint_only and { "eslint-plugin-prettier" } or { "eslint" })
    return
  end
  notify("eslint-lsp not found")
end

return function(notify)
  if vim.b.has_eslint_plugin_prettier == nil then
    vim.b.has_eslint_plugin_prettier = dkonode.has_eslint_plugin("prettier")
  end

  -- Run eslint via coc or nvim-lsp eslint-lsp
  if dkosettings.get("coc.enabled") then
    format_with_coc(notify)
  else
    format_with_lsp(notify)
  end

  -- Finally, run prettier via efm
  if not vim.b.has_eslint_plugin_prettier then
    local did_efm_format =
      require("dko.utils.format.efm").format({ pipeline = "javascript" })
    if not did_efm_format then
      vim.notify("Did not format", vim.log.levels.WARN, {
        title = "dko.utils.format.javascript",
      })
    end
  end
end
