# macOS/OS X

## Full generic setup, in order

### Install App Store apps

- `Amphetamine` - better than caffeine
- `Display Menu` - for setting native resolutions on multiple monitors
- `xcode`
    - Then run `xcode-select --install` to prompt for CLI tools.

### Setup ssh keys

1. keygen
1. add to GitHub
    - NEED alternate means of logging in via web
    - then do a test login and store the passphrase in Keychain
1. add to GitLab

### Install homebrew

### Install git from brew

Don't need completions, we'll use zsh completions instead

```bash
brew install git --without-completions
brew install git-extras hub
```

### Install dotfiles

1. `git clone`
1. `~/.dotfiles/bootstrap/symlink.sh`
1. `~/.dotfiles/mac/settings` -- set apple defaults and fix some issues like
   zsh startup

### Install macvim

We want this to override the outdated system vim too.

`~/.dotfiles/bootstrap/osx/macvim.sh` is good.

### Install zsh and set as default

```bash
brew install zsh
chsh -s /usr/local/bin/zsh
```

### Install Powerline patched fonts from source

1. `git clone https://github.com/powerline/fonts ~/src/fonts`
1. Run `install.sh`

### Install iterm2 from brew

1. Install `iterm2-beta`, which is technically iterm3:
    ```bash
    brew tap caskroom/versions
    brew cask install iterm2-beta
    ```
1. Set up fonts (Fura Mono for Powerline, see _Powerline patched fonts_ above)
1. Set up base16 theme from <https://github.com/chriskempson/base16-iterm2> or
   start app -> Preferences -> Load preferences from custom folder, point to
   existing plist exports.

### Install dev stuff

- Install `chruby`, `ruby-install`, and start using a local ruby
    - Then install the default gems using
      `~/.dotfiles/ruby/install-default-gems.sh`
- Install `nvm`, and start using a local node
    - Then install the default packages using `~/.dotfiles/node/install.sh`
- `brew install redis` for `redismru.vim` later

### Install neovim

1. Follow <https://github.com/neovim/homebrew-neovim>
1. Launch `nvim` and let `vim-plug` install itself, exit
1. Launch `nvim` and `:PlugInstall`, exit

### Install keepassx from source

Install keepassx 2.0 with http support from the source of this fork (inspect
diff first):
<https://github.com/eugenesan/keepassx/tree/2.0-http-totp>

It is fine to run the `cmake` step until it builds successfully (it will tell
you what deps are missing each time, and the deps can all be installed via
brew).

Known requirements:

- cmake
- libgcrypt
- oath-toolkit

### Install from cask

- dropbox
    - Then setup keepassx to load the key database from dropbox
- google-chrome
- karabiner
    - Map simultaneous-dual-shift to capslock and show capslock state.

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

