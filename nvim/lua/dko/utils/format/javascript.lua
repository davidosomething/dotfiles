local function format_with_coc()
  local formatter = ("coc-eslint%s"):format(
    vim.b.has_eslint_plugin_prettier and " + eslint-plugin-prettier" or ""
  )
  require("dko.utils.notify").toast(formatter, vim.log.levels.INFO, {
    group = "format",
    title = "[coc.nvim]",
    render = "wrapped-compact",
  })
  vim.fn.CocAction("runCommand", "eslint.executeAutofix")
  vim.cmd.sleep(vim.b.has_eslint_plugin_prettier and "100m" or "1m")
  return true
end

local function format_with_lsp()
  if vim.lsp.get_clients({ bufnr = 0, name = "eslint" }) == 0 then
    require("dko.utils.notify").toast(
      "eslint-lsp not attached",
      vim.log.levels.WARN,
      {
        group = "format",
        title = "[LSP] eslint-lsp",
        render = "wrapped-compact",
      }
    )
    return false
  end

  vim.cmd.EslintFixAll()
  local formatter = vim.b.has_eslint_plugin_prettier
      and "eslint-plugin-prettier"
    or "eslint-lsp"
  require("dko.utils.notify").toast(formatter, vim.log.levels.INFO, {
    group = "format",
    title = "[LSP] eslint-lsp",
    render = "wrapped-compact",
  })
  return true
end

return function()
  -- Find and buffer cache prettier presence
  if vim.b.has_eslint_plugin_prettier == nil then
    vim.b.has_eslint_plugin_prettier =
      require("dko.utils.node").has_eslint_plugin("prettier")
  end

  -- Run eslint via coc or nvim-lsp eslint-lsp
  if
    require("dko.settings").get("coc.enabled")
    and vim.iter(vim.g.coc_global_extensions):find(function(v)
      return string.find(v, "coc%-eslint")
    end)
  then
    format_with_coc()
  else
    format_with_lsp()
  end

  -- Finally, run prettier via efm if eslint-plugin-prettier not found
  if not vim.b.has_eslint_plugin_prettier then
    local did_efm_format =
      require("dko.utils.format.efm").format({ pipeline = "javascript" })
    if not did_efm_format then
      require("dko.utils.notify").toast(
        "Did not format with efm/prettier",
        vim.log.levels.WARN,
        {
          group = "format",
          title = "[LSP] efm",
          render = "wrapped-compact",
        }
      )
    end
    return did_efm_format
  end
end
