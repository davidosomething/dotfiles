local tools = require("dko.tools")

tools.register({
  name = "selene",
  fts = { "lua" },
  mason_type = "tool",
  require = "_",
  efm = function()
    ---@type EfmLinter
    return vim.tbl_extend(
      "force",
      require("efmls-configs.linters.selene"),
      { lintSource = "efmls" }
    )
  end,
})

tools.register({
  mason_type = "tool",
  require = "_",
  name = "stylua",
  fts = { "lua" },
  efm = function()
    ---@type EfmFormatter
    return vim.tbl_extend("force", require("efmls-configs.formatters.stylua"), {
      rootMarkers = { "stylua.toml", ".stylua.toml", ".editorconfig" },
    })
  end,
})

local M = {}

local nvim_dir = ("%s/nvim"):format(vim.env.XDG_CONFIG_HOME)
local after_dir = ("%s/after"):format(nvim_dir)

-- @TODO using this because of https://github.com/neovim/nvim-lspconfig/issues/3189
-- Need to call this after plugins loaded since they change runtime files
M.get_runtime_files = function()
  return vim
    .iter(vim.api.nvim_get_runtime_file("", true))
    :filter(function(v)
      return v ~= nvim_dir and v ~= after_dir
    end)
    :totable()
end

tools.register({
  mason_type = "lsp",
  require = "_",
  name = "lua_ls",
  runner = "mason-lspconfig",
  lspconfig = function()
    ---@type lspconfig.Config
    return {
      settings = {
        Lua = {
          format = { enable = false },
          hint = { enable = true },
          runtime = {
            -- Tell the language server which version of Lua you're using
            -- (most likely LuaJIT in the case of Neovim)
            version = "LuaJIT",
          },
          workspace = {
            maxPreload = 1000,
            preloadFileSize = 500,
            checkThirdParty = false,
            library = {
              -- provides vim.*
              vim.env.VIMRUNTIME,

              -- provide plugin completions and types
              -- pull in all of 'runtimepath'. NOTE: this is a lot slower
              -- unpack(vim.api.nvim_get_runtime_file("", true)),
              -- @TODO using this because of https://github.com/neovim/nvim-lspconfig/issues/3189
              unpack(M.get_runtime_files()),

              "${3rd}/luv/library",
              -- "${3rd}/busted/library",
            },
          },
        },
      },
    }
  end,
})

return M
