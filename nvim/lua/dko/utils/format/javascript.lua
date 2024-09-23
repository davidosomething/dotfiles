local dkosettings = require("dko.settings")
local dkonode = require("dko.utils.node")

function format_with_coc(notify)
  local eslint_only = vim.b.has_eslint_plugin_prettier
  notify(
    eslint_only and { "coc-eslint with eslint-plugin-prettier" }
      or { "coc-eslint" }
  )
  vim.cmd.call("CocAction('runCommand', 'eslint.executeAutofix')")
  vim.cmd.sleep(eslint_only and "250m" or "1m")

  if not eslint_only then
    notify({ "coc-prettier" })
    vim.cmd.call("CocAction('runCommand', 'prettier.formatFile')")
    vim.cmd.sleep("250m")
  end
end

function format_with_lsp(notify)
  local eslint_only = vim.b.has_eslint_plugin_prettier

  -- eslint-lsp
  vim.b.has_eslint = vim.b.has_eslint
    or #vim.lsp.get_clients({ bufnr = 0, name = "eslint" }) > 0
  if vim.b.has_eslint then
    vim.cmd.EslintFixAll()
    notify(eslint_only and { "eslint-plugin-prettier" } or { "eslint" })
  end

  if not eslint_only then
    local did_efm_format =
      require("dko.utils.format.efm").format({ pipeline = "javascript" })
    if not did_efm_format then
      vim.notify("Did not format", vim.log.levels.WARN, {
        title = "dko.utils.format.javascript",
      })
    end
  end
end

return function(notify)
  if vim.b.has_eslint_plugin_prettier == nil then
    vim.b.has_eslint_plugin_prettier = dkonode.has_eslint_plugin("prettier")
  end
  return dkosettings.get("coc.enabled") and format_with_coc(notify)
    or format_with_lsp(notify)
end
