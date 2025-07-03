local M = {}

---Detect eslint-plugin-prettier is installed
M.has_eslint_plugin_prettier = function()
  if vim.b.has_eslint_plugin_prettier == nil then
    vim.b.has_eslint_plugin_prettier =
      require("dko.utils.node").has_eslint_plugin("prettier")
  end
  return vim.b.has_eslint_plugin_prettier
end

---Detect coc-eslint is installed
M.has_coc_eslint = function()
  if vim.g.has_coc_eslint == nil then
    vim.g.has_coc_eslint = vim
      .iter(vim.g.coc_global_extensions)
      :find(function(v)
        return string.find(v, "coc%-eslint")
      end)
  end
  return vim.g.has_coc_eslint
end

---Detect coc-prettier is installed
M.has_coc_prettier = function()
  if vim.g.has_coc_prettier == nil then
    vim.g.has_coc_prettier = vim
      .iter(vim.g.coc_global_extensions)
      :find(function(v)
        return string.find(v, "coc%-prettier")
      end)
  end
  return vim.g.has_coc_prettier
end

---@return boolean
M.format_with_coc = function()
  local toast_opts = {
    group = "format",
    title = "[coc.nvim]",
    render = "wrapped-compact",
  }
  local toast = require("dko.utils.notify").toast

  local did_format = false

  if not M.has_eslint_plugin_prettier() and M.has_coc_prettier() then
    vim.cmd.CocCommand("prettier.forceFormatDocument")
    toast("coc-prettier", vim.log.levels.INFO, toast_opts)
    vim.cmd.sleep("100m") -- m is milliseconds
    did_format = true
  end

  if M.has_coc_eslint() then
    local message = M.has_eslint_plugin_prettier()
        and " + eslint-plugin-prettier"
      or ""
    toast(("coc-eslint%s"):format(message), vim.log.levels.INFO, toast_opts)
    vim.cmd.CocCommand("eslint.executeAutofix")
    vim.cmd.sleep("100m")
    did_format = true
  end

  return did_format
end

---@return boolean
M.format_with_lsp = function()
  local level = vim.log.levels.ERROR
  local message = "eslint-lsp"

  local eslint_lsps = vim.lsp.get_clients({ bufnr = 0, name = "eslint" })
  if #eslint_lsps == 0 then
    message = ("eslint-lsp not attached %s"):format(
      vim.b.has_eslint_plugin_prettier and "and eslint-plugin-prettier present"
        or ""
    )
  elseif vim.fn.exists(":LspEslintFixAll") then
    vim.cmd.LspEslintFixAll()
    message = M.has_eslint_plugin_prettier() and "eslint-plugin-prettier"
      or message
    level = vim.log.levels.INFO
  else
    message = "Missing :LspEslintFixAll from nvim-lspconfig"
  end

  require("dko.utils.notify").toast(message, level, {
    group = "format",
    title = "[LSP] eslint-lsp",
    render = "wrapped-compact",
  })
  return level ~= vim.log.levels.ERROR
end

M.format = function()
  -- Run eslint via coc or nvim-lsp eslint-lsp
  if require("dko.settings").get("coc.enabled") then
    return M.format_with_coc()
  end

  if M.format_with_lsp() then
    return true
  end

  -- Finally, run prettier via efm if eslint-plugin-prettier not found
  if not M.has_eslint_plugin_prettier() then
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

return M
