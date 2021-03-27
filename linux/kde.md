# KDE notes

## GPG and SSH

- Configure a `pinentry-program` in `$GNUPGHOME/gpg-agent.conf`
    - Use [gnupg/gpg-agent.conf](./gnupg/gpg-agent.conf) directly, or as
      a base template.
- `keychain` handles adding the GPG and SSH key to kwallet.

Install 

- kwalletcli from aur for kwalletaskpass and pinentry-kwallet
    - pinentry-kwallet can be used in gpg-agent.conf as the pinentry-program
    - Make sure to set PINENTRY to a real pinentry program like `pinentry-qt`.
      The `pinentry-kwallet` program just pipes some data around. See the
      comments in [kwalletcli-git aur](https://aur.archlinux.org/packages/kwalletcli-git/#comment-784686)
