# bin/

Helper scripts I've collected

## 24bit

Show truecolor colors in terminal

## 8bit

Show 8-bit colors in terminal

## addcert

Add a certificate

## brew-repair

`brew repair` to hard reset and brew update

## colortest

256color test script from
[base16-shell](https://github.com/chriskempson/base16-shell)

## curlperf

Simple alternative to apachebench to get request time for a URL

## dko-center

Output centered text

## dko-fix-git-completion

Remove the bash completion script for git since I only want zsh to use
site-functions.

## dko-header

Output bordered centered text

## dko-java_home

Get actual JRE home, not fake output of `java_home`
[source](http://sbndev.astro.umd.edu/wiki/Finding_and_Setting_JAVA_HOME)

## dko-line

Draw a terminal-width line using `=`

## dko-maybemkdir

Check for directory, prompt to create if it doesn't exist

## dko-open

`open` or `xdg-open`

## dko-same

Check if two filepaths are the same after resolving symlinks.

## dko-symlink

Check if path A is symlinked to path B, prompt to do so if not.

## dkosourced

Pretty print the `$DKO_SOURCE` env variable to see sourced files

## dot

Shortcuts to update dotfiles, packages, and general system maintenance.

## e

Open files in a shared nvim instance -- one per WezTerm tab, a single global
one elsewhere -- or fall back to $EDITOR

## egr

Edit a file in the git root

## enginx

Find and edit the nginx.conf file

## enofork

Open files in an nvim that neither forks nor shares a socket, and skips shada
-- for `$EDITOR` callers that have to block

## ephp

Find and edit the php.ini file

## ewez

Open `$EDITOR` in a new small WezTerm window, which closes when it exits

## flatten

Recursively flatten a directory

## fs

Get directory total filesize

## fu

Look upwards from $PWD for filename $1, output to `stdout` if found. Does not
follow symlinks.

## fzf-audio

macOS, FZF + SwitchAudioSource

## fzf-git-branch

FZF-interface for selecting a git branch

## fzf-git-latest-branches

FZF-interface for selecting a git branch including remotes, sorted by latest

## fzf-git-worktree

Switch to a different worktree using FZF

## fzf-xcode

Switch to a different XCode version

## get-wezterm

Download the nightly WezTerm AppImage matching this system's Ubuntu/glibc
version to `~/.local/bin/` (Linux)

## git-committers

List git committers and number of commits

## git-copy-branch

Copy a git branch

## git-dirsha

Print the SHA of the most recent commit, optionally limited to given paths

## git-ffm

Fast-forward local `main` to its remote, also from a bare-repo worktree

## git-in

Check if given directory is a git repository, and display its root and origin

## git-key

Get user's ssh public keys from GitHub

## git-lp

List pull requests since last tag

## git-open

Use GitHub or GitLab cli tools to open current repo in browser.
Fall back to dko-open if the repo origin is `https`.

## git-sbs

Side-by-side `git diff` using `delta` as the pager.
Takes regular `git diff` options.

## git-today

Show commits since midnight

## giteditor

`$GIT_EDITOR` wrapper -- [enofork](./enofork) with the editor context set

## jira-mine

List Jira issues assigned to me

## joingroup

Linux. Join a group and reload user's groups

## localip

Show user's local ip

## lockscreen

macOS. lock screen

## maybe-git-root

Echo the git root or pwd if not in git repo

## osc9-notify

Send a desktop notification through the terminal with an OSC 9 escape

## path

Pretty list path env

## pokecolor

pokemon

## prune

Delete empty subdirectories below the cwd, after confirming (`-y` to skip)

## rln

Rename a symlink's source file and update the symlink

## rmtags

Delete .git/tags if it exists in a repository

## serve

Start HTTP server in current directory

## ssid

Get current connected ssid

## steam-find-missing-lib32

Find missing steam libs in linux

## steam-find-missing-lib64

Find missing steam libs in linux

## termcolors

Display terminal colors

## togglemousescaling

Toggle macOS mouse acceleration (e.g. for gaming)

## wez-clean-socks

Remove the per-tab nvim sockets left behind by closed WezTerm tabs

## wez-tab-id

Print the WezTerm tab ID owning the current pane, so [e](./e) can scope its
nvim socket to the tab

## wifi-passwords

Get current wifi password in plaintext

## xcw

Open nearest \*.xcworkspace

