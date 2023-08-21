local null_ls = require("null-ls")

null_ls.setup({
  border = "rounded",
  -- defaults to false, but lets just sync it in case I want to change
  -- in my diagnostic.lua
  update_in_insert = vim.diagnostic.config().update_in_insert,
})

null_ls.register({ null_ls.builtins.hover.printenv })

-- =====================================================================
-- Configure formatters
-- =====================================================================

local formatters = {
  null_ls.builtins.formatting.isort.with({
    extra_args = { "--profile black" },
  }),
  null_ls.builtins.formatting.markdownlint,
  null_ls.builtins.formatting.qmlformat,

  -- yamlls formatting is disabled in favor of this
  null_ls.builtins.formatting.yamlfmt,
}

-- bind notify when a null_ls formatter has run
for i, provider in ipairs(formatters) do
  formatters[i] = provider.with({
    runtime_condition = function(params)
      local source = params:get_source()
      vim.notify(("format with %s"):format(source.name), vim.log.levels.INFO, {
        render = "compact",
        title = "LSP > null-ls",
      })

      local original = provider.runtime_condition
      return type(original) == "function" and original() or true
    end,
  })
end

null_ls.register(formatters)

-- =====================================================================
-- Configure diagnostics
-- =====================================================================

local diagnostics = {
  -- dotenv-linter will have to be installed manually
  null_ls.builtins.diagnostics.dotenv_linter.with({
    filetypes = { "dotenv" },
    extra_args = { "--skip", "UnorderedKey" },
  }),
  null_ls.builtins.diagnostics.markdownlint,
  null_ls.builtins.diagnostics.qmllint,

  null_ls.builtins.diagnostics.selene.with({
    condition = function()
      local homedir = vim.uv.os_homedir()
      local is_in_homedir = homedir
        and vim.api.nvim_buf_get_name(0):find(homedir)
      if not is_in_homedir then
        return false
      end
      local results = vim.fs.find({ "selene.toml" }, {
        path = vim.api.nvim_buf_get_name(0),
        type = "file",
        upward = true,
      })
      return #results > 0
    end,
    extra_args = function(params)
      local results = vim.fs.find({ "selene.toml" }, {
        path = vim.api.nvim_buf_get_name(0),
        type = "file",
        upward = true,
      })
      if #results == 0 then
        return params
      end
      return { "--config", results[1] }
    end,
  }),

  null_ls.builtins.diagnostics.zsh,
}
-- Switch ALL diagnostics to DIAGNOSTICS_ON_SAVE only
-- or null_ls will keep spamming LSP events
--[[ for i, provider in ipairs(diagnostics) do
        -- @TODO handle existing runtime_condition?
        diagnostics[i] = provider.with({
          method = null_ls.methods.DIAGNOSTICS_ON_SAVE,
        })
      end ]]

null_ls.register(diagnostics)
