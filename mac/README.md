# macOS

User data on encrypted volumes other than the boot volume will not mount until
login. To remedy this, see [Unlock] (forked to my GitHub for archival).

1. OPTIONAL iCloud sign in
1. OPTIONAL install App Store apps, Xcode
1. Manually disable some keyboard shortcuts. Remove these using System Preferences:
    - `Keyboard` disable a bunch of things in `Text Replacements`
    - `Mission Control` owns <kbd>⌃</kbd><kbd>←</kbd> and <kbd>⌃</kbd><kbd>→</kbd>
    - `Spotlight` owns <kbd>⌘</kbd><kbd>space</kbd>
      - I remap this to hammerspoon's seal instead.
    - Disable `Trackpad` various Zoom options.
1. Follow step 1 of the repo [README.md](../README.md).
1. Install homebrew according to <https://brew.sh/>.
1. Install base `Brewfile` (or `personal.Brewfile`):

    ```sh
    brew bundle --file=~/.dotfiles/mac/Brewfile
    # or
    # brew bundle --file=~/.dotfiles/mac/personal.Brewfile
    ```

1. Start bettertouchtool and hammerspoon

## Cask notes

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
    multiple times)

[unlock]: https://github.com/davidosomething/Unlock
