# macOS/OS X

User data on encrypted volumes other than the boot volume will not mount until
login. To remedy this, see [Unlock] (forked to my GitHub for archival).

## Disable some keyboard shortcuts

Remove these using System Preferences:

- `Mission Control` owns <kbd>⌃</kbd><kbd>←</kbd> and <kbd>⌃</kbd><kbd>→</kbd>
- `Spotlight` owns <kbd>⌘</kbd><kbd>space</kbd>

## Reduce desktop icon size

Click desktop to focus Finder, <kbd>⌘</kbd><kbd>j</kbd> use smallest sizes for
everything.

## App store

1. iCloud sign in
1. Install App store apps
   - [Display Menu]: Set higher/native resolutions
   - [Xcode]: select CLI tools in prefs
      - This is __required__ to build some apps like neovim@HEAD

## Install homebrew

1. Install according to <https://brew.sh/>. Install bundles in a later step.

## Install dotfiles

```sh
git clone https://github.com/davidosomething/dotfiles.git ~/.dotfiles/
```

## Run bootstrap/mac

Mojave no longer installs SDK headers for building certain things. It comes
with mac OS but requires manual execution. Use
[bootstrap/mac](../bootstrap/mac) to install it:

```sh
~/.dotfiles/bootstrap/mac
```

The script will also:

- load the `dotfiles.plist`
- `brew bundle` some default packages
- Run the fzf installer
- Change the user's default shell to the brewed `zsh`

### System-specific

Bundle dumps for specific systems are in my `~/.secret` (not public).

### the dotfiles.plist

`./compile dotfiles.plist.json` generates the `dotfiles.plist` file in the
`mac/LaunchAgents` directory. It depends on the `plist` package from npm.
Redirect the compiled output to the plist file to update.
There is a limitation that it uses `$HOME/.dotfiles` instead of `$DOTFILES`
so you may want to edit (e.g. hardcode) the dotfiles path if you changed it.

The bootstrap script symlinks the plist. You'll have to manually use
`launchctl` command to load it and reboot to start it if you opt in.

See homebrew notes in [brew.md](brew.md) for other formulae I install.

## Casks

- dropbox
    - Has app settings sync so wait for it to finish syncing.
        - Including some `mackup` backups
- iterm2
    - Run [bootstrap/iterm2](../bootstrap/iterm2) after installation to load
      my standard [Dynamic Profile](https://www.iterm2.com/documentation-dynamic-profiles.html)
      with base16-Tomorrow-Night colors, Fura Mono for Powerline font, and
      some window settings and key mappings.
- bettertouchtool
    - License in synology drive or gmail
    - Better trackpad swipe configs
    - Synced to Dropbox
- hammerspoon
    - App launcher (<kbd>⌘</kbd><kbd>space</kbd>) - disable spotlight shortcut
      first
    - Audio output device switch in menubar
    - Auto-type from clipboard (<kbd>⌃</kbd><kbd>⌘</kbd><kbd>v</kbd>)
    - Caffeinate in menubar
    - Window management
      (<kbd>⌃</kbd><kbd>⌘</kbd><kbd>⇧</kbd><kbd>f/h/l/z</kbd>)

Install the rest of the packages from [cask.md](./cask.md) as desired.

## mackup

A `.mackup.cfg` defines some app settings (such as the itsycal plist) that
I don't keep version controlled (just in dropbox). Run `mackup restore` to
restore them (`mackup` is in the Brewfile).

## Install GPGTools and import key

1. Install the [dotfiles.plist](LaunchAgents/dotfiles.plist) first! It sets
   `GNUPGHOME` in the env for all apps. See the bootstrapping section above.
1. Follow these instructions
   <https://gist.github.com/danieleggert/b029d44d4a54b328c0bac65d46ba4c65>  
   then
    - Export key from keybase
    - Import key
    - Add User ID to key

## Setup ssh keys

1. `sshkeygen` (alias to generate new ed25519 keys)
1. Add the public key to GitHub, GitLab, Bitbucket, keybasefs, etc.
1. `ssh-add -K ~/.ssh/privatekeyfile` to store the key in Keychain.

## Install development tools

Installed packages before development tools. After you start using `pyenv` it
gets annoying to remember to switch back to system python for each `brew`
operation. Use the `bi` alias for a clean room install if possible.

- Increase file limits a la
  <https://github.com/karma-runner/karma/issues/1979#issuecomment-260790451>
    - See <https://gist.github.com/abernix/a7619b07b687bb97ab573b0dc30928a0>
      if there are still file limit issues
    - REBOOT for `ulimit -n` changes to take effect
- Install `chruby`, `ruby-install`
  1. `ruby-install ruby` to install latest
  1. `chruby` to that version
  1. Install gems using [ruby/install-default-gems](../ruby/install-default-gems)
- Install [nvm] MANUALLY via git clone into `$XDG_CONFIG_HOME`, then use it to
  install a version of `node` (and `npm`)
  1. Use nvm managed node
  1. Install the default packages using [node/install](../node/install)
- Install [pyenv] using `pyenv-installer` (rm `~/.local/pyenv` directory for
  clean install) and make sure to use the libs provided by `brew openssl`
  1. `brew install openssl`
  1. Follow <https://github.com/yyuu/pyenv/wiki/Common-build-problems#error-the-python-ssl-extension-was-not-compiled-missing-the-openssl-lib>
  1. Set up the global pyenv as the latest stable (3.x)
  1. Set up python virtualenvs using [bootstrap/pyenv](../bootstrap/pyenv)


[nvm]: https://github.com/nvm-sh/nvm
[pyenv]: https://github.com/pyenv/pyenv
[unlock]: https://github.com/davidosomething/Unlock
[Display Menu]: https://apps.apple.com/us/app/display-menu/id549083868?mt=12
[Xcode]: https://apps.apple.com/us/app/xcode/id497799835?mt=12
