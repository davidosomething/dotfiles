local tools = require("dko.tools")

-- can't get it to find typescript in my nx project
-- also this issue https://github.com/neovim/neovim/issues/37204
-- LSP[mdx_analyzer]: Error SERVER_REQUEST_HANDLER_ERROR: "...2.2/nvim-macos-arm64/share/nvim/runtime/lua/vim/glob.lua:373: Invalid glob: **/*.{mdx}"
-- tools.register({
--   name = "mdx_analyzer",
--   runner = "lspconfig",
-- })
