local M = {}

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

---@return boolean
M.format_with_coc = function()
  local toast_opts = {
    group = "format",
    title = "[coc.nvim]",
    render = "wrapped-compact",
  }
  local toast = require("dko.utils.notify").toast

  local did_format = false

  local has_eslint_plugin_prettier =
    require("dko.utils.format.eslint").has_eslint_plugin_prettier()

  if
    not has_eslint_plugin_prettier
    and require("dko.utils.format.coc").has_coc_prettier()
  then
    vim.cmd.CocCommand("prettier.forceFormatDocument")
    toast("coc-prettier", vim.log.levels.INFO, toast_opts)
    vim.cmd.sleep("100m") -- m is milliseconds
    did_format = true
  end

  if M.has_coc_eslint() then
    local message = has_eslint_plugin_prettier and " + eslint-plugin-prettier"
      or ""
    toast(("coc-eslint%s"):format(message), vim.log.levels.INFO, toast_opts)
    vim.cmd.CocCommand("eslint.executeAutofix")
    vim.cmd.sleep("100m")
    did_format = true
  end

  return did_format
end

---@return boolean, boolean -- success, formatted
M.format_with_lsp = function()
  local level = vim.log.levels.ERROR
  local message = "eslint-lsp"

  local has_eslint_plugin_prettier =
    require("dko.utils.format.eslint").has_eslint_plugin_prettier()

  local eslint_lsps = vim.lsp.get_clients({ bufnr = 0, name = "eslint" })
  if #eslint_lsps == 0 then
    message = ("eslint-lsp not attached %s"):format(
      has_eslint_plugin_prettier and "and eslint-plugin-prettier present" or ""
    )
  elseif vim.fn.exists(":LspEslintFixAll") then
    vim.cmd.LspEslintFixAll()
    message = has_eslint_plugin_prettier and "eslint-plugin-prettier" or message
    level = vim.log.levels.INFO
  else
    message = "Missing :LspEslintFixAll from nvim-lspconfig"
  end

  require("dko.utils.notify").toast(message, level, {
    group = "format",
    title = "[LSP] eslint-lsp",
    render = "wrapped-compact",
  })
  return level ~= vim.log.levels.ERROR, has_eslint_plugin_prettier
end

M.format = function()
  -- Run eslint via coc or nvim-lsp eslint-lsp
  if require("dko.settings").get("coc.enabled") then
    return M.format_with_coc()
  end

  local _, is_lsp_formatted = M.format_with_lsp()
  if is_lsp_formatted then
    return true
  end

  if require("dko.utils.format.biome").has_biome() then
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

  -- Finally, run prettier via efm if eslint-plugin-prettier not found
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

return M
