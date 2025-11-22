# macOS

User data on encrypted volumes other than the boot volume will not mount until
login. To remedy this, see [Unlock] (forked to my GitHub for archival).

## App Store

1. iCloud sign in
1. Install App Store apps, Xcode

## Install dotfiles

```sh
git clone https://github.com/davidosomething/dotfiles.git ~/.dotfiles/
~/.dotfiles/bootstrap/symlink
# restart terminal
```

## Setup ssh keys

1. Use `sshkeygen` alias to generate new Ed25519 keys
1. Add the public key to GitHub, GitLab, Bitbucket, etc.
1. Optionally change the `~/.dotfiles` origin protocol to SSH

## Install homebrew and install packages

Install homebrew according to <https://brew.sh/>. Install base `Brewfile` (or `personal.Brewfile`).

```sh
brew bundle --file=~/.dotfiles/mac/Brewfile
# brew bundle --file=~/.dotfiles/mac/personal.Brewfile
```

### Cask notes

- bettertouchtool
  - I keep my license in syncthing/gmail/bitwarden
  - Most important thing is three-finger click to middle click
  - Provides better trackpad swipe configs, drag window snapping,
    modifier-hold window resizing
- hammerspoon
  - App launcher (<kbd>⌘</kbd><kbd>space</kbd>) to replace spotlight
    (disable spotlight shortcut first)
  - Audio output device switch in menu bar, relies on `switchaudio-osx` which
    is in homebrew
  - Auto-type from clipboard (<kbd>⌃</kbd><kbd>⌘</kbd><kbd>v</kbd>) for
    paste blockers
  - Caffeinate icon in menu bar
  - Window management keys to use sections of a monitor (try hitting the key
    multiple times) and to throw apps to the next monitor
    (<kbd>⌃</kbd><kbd>⌘</kbd><kbd>⇧</kbd><kbd>f/h/l/z/[/]</kbd>)

## Manually disable some keyboard shortcuts

Remove these using System Preferences:

- `Keyboard` disable a bunch of things in `Text Replacements`
- `Mission Control` owns <kbd>⌃</kbd><kbd>←</kbd> and <kbd>⌃</kbd><kbd>→</kbd>
- `Spotlight` owns <kbd>⌘</kbd><kbd>space</kbd>
  - I remap this to hammerspoon's seal instead.
- Disable `Trackpad` various Zoom options.

[unlock]: https://github.com/davidosomething/Unlock
