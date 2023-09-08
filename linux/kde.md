# KDE notes

## GPG and SSH

- Configure a `pinentry-program` in `$GNUPGHOME/gpg-agent.conf`
  - Use [gnupg/gpg-agent.conf](./gnupg/gpg-agent.conf) directly, or as
    a base template.
  - I actually like `pinentry-gtk-2` even on KDE since it themes nicer and
    I don't use kvantum. It has an optional dependency on
    `gtk-engine-murrine` that will silence cli errors. - Make sure to set the `PINENTRY` environment variable to a real
    pinentry program like `pinentry-qt`.
