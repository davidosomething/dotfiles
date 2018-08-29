#!/usr/bin/env bash

# <bitbar.title>Docker</bitbar.title>
# <bitbar.version>v1.0</bitbar.version>
# <bitbar.author>David O'Trakoun</bitbar.author>
# <bitbar.author.github>davidosomething</bitbar.author.github>
# <bitbar.desc>Docker container status</bitbar.desc>
# <bitbar.dependencies>docker</bitbar.dependencies>

PATH="/usr/local/bin:${PATH}"
readonly docker="$(command -v docker)"

list_containers() {
  readonly containers="$(docker ps --all --filter status=running --format "{{.Names}}")"
  if [ -z "$containers" ]; then
    echo "No running containers"
  else
    echo "${containers}"
  fi
}

main() {
  [[ -z "$docker" ]] && exit 0
  echo "D | dropdown=false"
  echo "---"
  list_containers
}

main
