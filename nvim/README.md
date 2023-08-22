# nvim config

nvim config, crafted for **nightly builds only**! Configured in lua.

> Don't use what you don't understand.

![nvim screenshot][screenshot]

> pictured: neovim running in [Wezterm](https://github.com/wez/wezterm)
> using font [Maple Mono](https://github.com/subframe7536/maple-font)
> and colorscheme [vim-colors-meh](https://github.com/davidosomething/vim-colors-meh).  
> Tabline: the cwd is a project root; `dev` branch; there is one dirty buffer out of four total; and we are connected to nvim.sock  
> Winbar: Treesitter highlighting is enabled, orange filenames are dirty files, and there are no diagnostic issues.  
> Signs: [gitsigns](https://github.com/lewis6991/gitsigns.nvim) is active.  
> Indent: [hlchunk](https://github.com/shellRaining/hlchunk.nvim) is displaying the current indent chunk.  
> Status: Normal mode; `type` is searched with one occurrence found; ruler  

| Tool              | Link |
| ----------------- | ------------------------------------------------------- |
| Plugin manager    | [lazy.nvim](https://github.com/folke/lazy.nvim) |
| LSP/tool manager  | [mason.nvim](https://github.com/williamboman/mason.nvim)
| Local LSP         | [efm-langserver](https://github.com/mattn/efm-langserver) and [null-ls](https://github.com/jose-elias-alvarez/null-ls.nvim) |
| File finder       | [telescope](https://github.com/nvim-telescope/telescope.nvim) |
| Status/tab/winbar | [heirline](https://github.com/rebelot/heirline.nvim) |

## custom things

- all mappings in mappings.lua
- if using my dotfiles, [e](https://github.com/davidosomething/dotfiles/blob/dev/bin/e) is the preferred way to open files.
    - it will create a new nvim.sock if one does not exist
    - it will use a single nvim instance over the socket otherwise
- if using my wezterm config, `<C-S-t>` will toggle the terminal and neovim
  theme between light and dark mode.
- lsp/tool config is done in [dko/tools/](https://github.com/davidosomething/dotfiles/tree/dev/nvim/lua/dko/tools)
    - lspconfig, efm, and null-ls all handled in one place
- formatting is handled in [dko/format.lua](https://github.com/davidosomething/dotfiles/blob/dev/nvim/lua/dko/format.lua)
    - of note is a pipeline that can run eslint only, eslint and then
      prettier, or prettier only as needed

----

[screenshot]: https://raw.githubusercontent.com/davidosomething/dotfiles/dev/meta/nvim-potatosff.png
