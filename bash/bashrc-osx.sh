command -v brew >/dev/null 2>&1 && {
  export _Z_CMD=j
  source "`brew --prefix`/etc/profile.d/z.sh"
}
