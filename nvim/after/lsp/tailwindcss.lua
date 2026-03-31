---@type vim.lsp.Config
return {
  ---@type lspconfig.settings.tailwindcss
  settings = {
    tailwindCSS = {
      classFunctions = {
        "clsx",
        "cn",
        "cva",
        "cx",
        "twMerge",
      },
    },
  },
}
