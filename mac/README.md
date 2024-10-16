# macOS

User data on encrypted volumes other than the boot volume will not mount until
login. To remedy this, see [Unlock] (forked to my GitHub for archival).

## App store

1. iCloud sign in
1. Install App store apps, XCode

## Install homebrew and bootstrap

Install homebrew according to <https://brew.sh/>.

## Install dotfiles

```sh
git clone https://github.com/davidosomething/dotfiles.git ~/.dotfiles/
cd ~/.dotfiles
./bootstrap/symlink
# restart terminal
```

## Setup ssh keys

1. `sshkeygen` (alias to generate new ed25519 keys)
1. Add the public key to GitHub, GitLab, Bitbucket, etc.
1. `ssh-add -K ~/.ssh/privatekeyfile` to store the key in Keychain.
1. Optionally change the `~/.dotfiles` origin protocol to SSH

## Brew

```sh
cd ~/.dotfiles/mac
brew bundle
```

This installs some packages I would use on every mac, whether it's a personal
or work machine. For personal machines I also install:

- bitwarden
- discord
- notion-calendar
- standard-notes
- syncthing
- tailscale

Bundle dumps for specific systems are in my `~/.secret` (not public).

## Cask notes

- bettertouchtool
  - I keep my license in syncthing/gmail/bitwarden
  - Most important thing is three-finger click to middle click
  - Provides better trackpad swipe configs, drag window snapping,
    modifier-hold window resizing
- hammerspoon
  - App launcher (<kbd>⌘</kbd><kbd>space</kbd>) to replace spotlight
    (disable spotlight shortcut first)
  - Audio output device switch in menubar, relies on `switchaudio-osx` which
    is in homebrew
  - Auto-type from clipboard (<kbd>⌃</kbd><kbd>⌘</kbd><kbd>v</kbd>) for
    paste blockers
  - Caffeinate in menubar
  - Window management keys to use sections of a monitor (try hitting the key
    multiple times) and to throw apps to the next monitor
    (<kbd>⌃</kbd><kbd>⌘</kbd><kbd>⇧</kbd><kbd>f/h/l/z/[/]</kbd>)

## mackup

`mackup` backs up application settings. It will be installed if using this
repo's Brewfile.

`dot.mackup.cfg` defines some app settings (such as the itsycal plist). It is
symlinked to `~/.mackup.cfg` by `bootstrap/symlink`.

Mackup is configured to use `~/.local/Mackup` as the storage location. On my
system this is a symlink to a private settings repository.

Run `mackup restore` to restore settings from that repository.

## Manually disable some keyboard shortcuts

Remove these using System Preferences:

- `Mission Control` owns <kbd>⌃</kbd><kbd>←</kbd> and <kbd>⌃</kbd><kbd>→</kbd>
- `Spotlight` owns <kbd>⌘</kbd><kbd>space</kbd>
  - I map this to hammerspoon's seal instead.

[unlock]: https://github.com/davidosomething/Unlock
