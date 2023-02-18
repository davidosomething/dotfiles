# KDE notes

## Konsole

Check for anything to keep in `~/.local/share/konsole`
Ideally, we want to:

```sh
rm -rf ~/.local/share/konsole
ln -sf ~/.dotfiles/linux/konsole ~/.local/share/konsole
```

Then restart konsole, set `davidosomething` as the default profile.

## GPG and SSH

- Configure a `pinentry-program` in `$GNUPGHOME/gpg-agent.conf`
    - Use [gnupg/gpg-agent.conf](./gnupg/gpg-agent.conf) directly, or as
      a base template.
    - I actually like `pinentry-gtk-2` even on KDE since it themes nicer and
      I don't use kvantum. It has an optional dependency on
      `gtk-engine-murrine` that will silence cli errors.
          - Make sure to set the `PINENTRY` environment variable to a real
            pinentry program like `pinentry-qt`.  
