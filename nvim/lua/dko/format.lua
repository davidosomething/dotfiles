-- Code formatting pipelines

---@param names string[]
local function notify(names)
  if #names == 0 then
    return
  end
  vim.notify("format", vim.log.levels.INFO, {
    render = "compact",
    title = ("LSP > %s"):format(table.concat(names, ", ")),
  })
end

local M = {}

-- NO eslint-plugin-prettier? maybe run prettier
-- then, maybe run eslint --fix
local format_jsts = function()
  vim.b.has_eslint = vim.b.has_eslint
    or #vim.lsp.get_clients({ bufnr = 0, name = "eslint" }) > 0

  if vim.b.has_eslint then
    if vim.b.has_eslint_plugin_prettier == nil then
      vim.b.has_eslint_plugin_prettier =
        require("dko.node").has_eslint_plugin("prettier/prettier")
    end

    vim.cmd.EslintFixAll()

    if vim.b.has_eslint_plugin_prettier then
      vim.notify("format with eslint+prettier/prettier", vim.log.levels.INFO, {
        render = "compact",
        title = "LSP > eslint",
      })
      return
    end

    notify({ "eslint" })
  end

  require("dko.format.efm").format()
end

-- @TODO WIP not used yet
local format_markdown = function()
  if vim.b.has_markdownlint == nil then
    vim.b.has_markdownlint = #vim.fs.find({
      ".markdownlint.json",
      ".markdownlint.jsonc",
      ".markdownlint.yaml",
    }, { limit = 1, upward = true, type = "file" })
  end
  require("dko.format.efm").format_with(
    vim.b.has_markdownlint == true and "markdownlint" or "prettier"
  )
end

-- ===========================================================================

local pipelines = {
  html = require("dko.format.efm").format,

  typescript = format_jsts,
  typescriptreact = format_jsts,
  javascript = format_jsts,
  javascriptreact = format_jsts,

  json = function()
    require("dko.format.efm").format_with("prettier")
  end,
  jsonc = function()
    require("dko.format.efm").format_with("prettier")
  end,

  lua = function()
    require("dko.format.efm").format_with("stylua")
  end,

  markdown = function()
    -- @TODO use the pipeline, but markdownlint formatter not working
    -- @see https://github.com/mattn/efm-langserver/issues/258
    require("dko.format.efm").format_with("prettier")
  end,

  yaml = function()
    local filename = vim.fn.fnamemodify(vim.api.nvim_buf_get_name(0), ":t")
    if
      filename == "docker-compose.yml" or filename == "docker-compose.yaml"
    then
      vim.lsp.buf.format({ name = "docker_compose_language_service" })
      notify({ "docker_compose_language_service" })
      return
    end
    require("dko.format.efm").format_with("yamlfmt")
  end,
}

--- See options for vim.lsp.buf.format
M.run_pipeline = function(options)
  local pipeline = pipelines[vim.bo.filetype]
  if pipeline then
    return pipeline()
  end

  local names = {}
  options = vim.tbl_deep_extend("force", options or {}, {
    filter = function(client)
      if
        not client.supports_method(
          vim.lsp.protocol.Methods.textDocument_formatting
        )
      then
        return false
      end

      if client.name == "efm" then
        local configs =
          require("dko.tools").get_efm_languages()[vim.bo.filetype]
        local filtered = vim.tbl_filter(function(config)
          if config.formatCommand ~= nil then
            table.insert(
              names,
              ("efm[%s]"):format(
                vim.fn.fnamemodify(config.formatCommand:match("([^%s]+)"), ":t")
              )
            )
            return true
          end
          return false
        end, configs)
        return #filtered ~= 0
      end

      table.insert(names, client.name)
      return true
    end,
  })

  -- https://github.com/neovim/neovim/blob/master/runtime/lua/vim/lsp/buf.lua#L156-L196
  vim.lsp.buf.format(options)
  notify(names)
end

return M
