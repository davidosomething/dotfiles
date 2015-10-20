if [ -d "$HOME/.nvm" ] && [ "$NVM_DIR" != "$HOME/.nvm" ]; then
  mkdir -p "$NVM_DIR"
  mv "$HOME/.nvm/*" "$NVM_DIR"
  rmdir "$HOME/.nvm"
fi
