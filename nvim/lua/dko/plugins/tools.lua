return {
  {
    "williamboman/mason.nvim",
    lazy = false,
    config = function()
      require("mason").setup({
        ui = {
          border = "rounded",
          icons = {
            package_installed = "",
            package_pending = "󱍷",
            package_uninstalled = "",
          },
        },
      })
      -- Auto-install some linters for efm
      -- https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/plugins/lsp/init.lua#L157-L163
      -- https://github.com/jay-babu/mason-null-ls.nvim/blob/main/lua/mason-null-ls/automatic_installation.lua#LL68C19-L75C7
      local mr = require("mason-registry")
      vim.iter(require("dko.tools").get_tools()):each(function(tool)
        local p = mr.get_package(tool)
        if p:is_installed() then
          return
        end
        vim.notify(
          ("Installing %s"):format(p.name),
          vim.log.levels.INFO,
          { title = "mason", render = "compact" }
        )
        local handle_closed = vim.schedule_wrap(function()
          return p:is_installed()
            and vim.notify(
              ("Successfully installed %s"):format(p.name),
              vim.log.levels.INFO,
              { title = "mason", render = "compact" }
            )
        end)
        p:install():once("closed", handle_closed)
      end)
    end,
  },
}
