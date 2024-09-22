local dkosettings = require("dko.settings")
local dkonode = require("dko.utils.node")

-- NO eslint-plugin-prettier? maybe run prettier
-- then, maybe run eslint --fix
return function(notify)
  -- coc-eslint
  if dkosettings.get("coc.enabled") then
    if vim.b.has_eslint_plugin_prettier == nil then
      vim.b.has_eslint_plugin_prettier = dkonode.has_eslint_plugin("prettier")
    end
    vim.cmd.CocCommand("eslint.executeAutofix")
    if vim.b.has_eslint_plugin_prettier then
      notify({ "coc-eslint with eslint-plugin-prettier" })
      return
    end
    notify({ "coc-eslint" })

    vim.cmd.CocCommand("prettier.formatFile")
    notify({ "coc-prettier" })
    return
  end

  -- eslint-lsp
  vim.b.has_eslint = vim.b.has_eslint
    or #vim.lsp.get_clients({ bufnr = 0, name = "eslint" }) > 0
  if vim.b.has_eslint then
    if vim.b.has_eslint_plugin_prettier == nil then
      vim.b.has_eslint_plugin_prettier = dkonode.has_eslint_plugin("prettier")
    end
    vim.cmd.EslintFixAll()
    if vim.b.has_eslint_plugin_prettier then
      notify({ "eslint-plugin-prettier" })
      return
    end
    notify({ "eslint" })
    return
  end

  local did_efm_format =
    require("dko.utils.format.efm").format({ pipeline = "javascript" })
  if not did_efm_format then
    vim.notify("Did not format", vim.log.levels.WARN, {
      title = "dko.utils.format.javascript",
    })
  end
end
