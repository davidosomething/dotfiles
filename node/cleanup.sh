mkdir -p "$NVM_DIR"

if [ -d "$HOME/.nvm" ] && [ "$NVM_DIR" != "$HOME/.nvm" ]; then
  mv "$HOME/.nvm/*" "$NVM_DIR"
  rmdir "$HOME/.nvm"
fi

if [ -d "$XDG_CONFIG/.nvm" ] && [ "$NVM_DIR" != "$XDG_CONFIG/.nvm" ]; then
  mv "$XDG_CONFIG/.nvm/*" "$NVM_DIR"
  rmdir "$XDG_CONFIG/.nvm"
fi
