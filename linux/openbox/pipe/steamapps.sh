#!/bin/bash

_steamapps() {
  local id
  local name

  echo '<openbox_pipe_menu>'
  echo '<item label="Steam"><action name="Execute"><execute>steam</execute></action></item>'
  echo '<separator/>'
  for file in $STEAMAPPS/*.acf; do
    name=$(grep '"name"' "$file" | head -1 | sed -r 's/[^"]*"name"[^"]*"([^"]*)"/\1/')
    id=$(grep '"appid"' "$file" | head -1 | sed -r 's/[^"]*"appid"[^"]*"([^"]*)"/\1/')
    echo "<item label=\"$name\"><action name=\"Execute\"><execute>steam steam://run/$id</execute></action></item>"
  done
  echo '</openbox_pipe_menu>'
}

_steamapps