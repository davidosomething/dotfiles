# OSX

## iterm2

Set up iterm2 with fonts and base16 theme
<https://github.com/chriskempson/base16-iterm2>

My iterm2 plist file is kept in a separate repo.

## keepassx

Install keepassx 2.0 with http support using this fork (inspect diff first):
<https://github.com/eugenesan/keepassx/tree/2.0-http-totp-2.0.0>

## Source order

- zshenv
    - shell/vars
        - shell/xdg
- /etc/zprofile
- zsh/.zprofile
- zshrc
    - shell/before
        - shell/path
        - shell/os
        - shell/functions
        - shell/x11
        - shell/aliases
        - shell/node
            - nvm
            - avn
        - shell/python
        - shell/ruby
            - chruby
    - zplug
        - keybindings.zsh
        - prompt.zsh
        - title.zsh
    - fzf
    - shell/after
        - travis
    - .secret/local/shellrc

