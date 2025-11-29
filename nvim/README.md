# nvim config

Neovim config, crafted for **nightly builds only**! Configured in Lua.

> Don't use what you don't understand.

![nvim screenshot][screenshot]

> pictured: Neovim in [WezTerm] with font [Maple Mono] and [vim-colors-meh].  
> Tabline: the cwd is a project root; `dev` branch; there is one dirty buffer out of four total; and we are connected to nvim.sock  
> Winbar: Tree-sitter highlighting is enabled, orange filenames are dirty files, and there are no diagnostic issues.  
> Signs: [gitsigns] is active.  
> Status: Normal mode; `type` is searched with one occurrence found; ruler

| Tool              | Link             |
| ----------------- | ---------------- |
| Plugin manager    | [lazy.nvim]      |
| Colorscheme       | [vim-colors-meh] |
| Completions       | [blink.nvim]     |
| Status/tab/winbar | [heirline.nvim]  |
| Local LSP         | [efm-langserver] |
| File finder       | [snacks.nvim]    |

## custom things

- LSPs and external tools are expected to be installed via mise (as opposed to
  something like mason.nvim). This allows them to be used in neovim, in the
  CLI, and by coding agents alike.
- mappings should be defined in [mappings.lua](./lua/dko/mappings.lua) or the
  mappings subdirectory.
- the preferred way command to open files is with [e](../bin/e)
  - it will create a new `nvim.sock` if one does not exist
  - it will use a single Neovim instance over the socket otherwise
- if using my WezTerm config, `<C-S-t>` will toggle the terminal and Neovim
  theme between light and dark mode.
- LSP/tool config is done in [dko/tools.lua](.lua/dko/tools.lua)
  - Both vtsls and coc.nvim are configured for JS/TS(x)
    - Change `coc.enabled` in `dko.settings` to switch
    - Still evaluating coc.nvim as it sometimes runs faster on large codebases
    - can still trigger regular nvim-cmp completions for other LSPs using
      `<C-Space>`
- formatting is handled in [dko/utils/format.lua](./lua/dko/utils/format.lua)
  - of note is a pipeline that runs, based on project configuration one of:
    - ESLint exclusively
    - ESLint followed by prettier, or
    - prettier exclusively

---

[screenshot]: https://raw.githubusercontent.com/davidosomething/dotfiles/dev/meta/nvim-potatosff.png
[blink.nvim]: https://github.com/Saghen/blink.cmp
[Maple Mono]: https://github.com/subframe7536/maple-font
[lazy.nvim]: https://github.com/folke/lazy.nvim
[gitsigns]: https://github.com/lewis6991/gitsigns.nvim
[vim-colors-meh]: https://github.com/davidosomething/vim-colors-meh
[efm-langserver]: https://github.com/mattn/efm-langserver
[heirline.nvim]: https://github.com/rebelot/heirline.nvim
[WezTerm]: https://github.com/wez/wezterm
[snacks.nvim]: https://github.com/folke/snacks.nvim
