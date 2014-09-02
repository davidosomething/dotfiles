git clone "https://github.com/WordPress-Coding-Standards/WordPress-Coding-Standards.git" "$HOME/src/wpcs"

# on arch
#phpcs --config-set installed_paths "/home/davidosomething/src/wpcs,/home/davidosomething/.composer/vendor/squizlabs/php_codesniffer/CodeSniffer"

# on osx
if [ -n "$HAS_BREW" ]; then
  phpcs --config-set installed_paths "$HOME/src/wpcs,$(brew --prefix)/etc/php-code-sniffer/Standards,$(brew --prefix)/Cellar/php-code-sniffer/1.5.4/CodeSniffer"
fi
