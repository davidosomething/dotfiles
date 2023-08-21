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
      -- Auto-install some linters for null-ls
      -- https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/plugins/lsp/init.lua#L157-L163
      -- https://github.com/jay-babu/mason-null-ls.nvim/blob/main/lua/mason-null-ls/automatic_installation.lua#LL68C19-L75C7
      local mr = require("mason-registry")
      for _, tool in ipairs(require("dko.tools").get_auto_installable()) do
        local p = mr.get_package(tool)
        if not p:is_installed() then
          vim.notify(
            ("Installing %s"):format(p.name),
            vim.log.levels.INFO,
            { title = "mason", render = "compact" }
          )
          p:install():once(
            "closed",
            vim.schedule_wrap(function()
              if p:is_installed() then
                vim.notify(
                  ("Successfully installed %s"):format(p.name),
                  vim.log.levels.INFO,
                  { title = "mason", render = "compact" }
                )
              end
            end)
          )
        end
      end
    end,
  },
}
