#!/usr/bin/env bash

# <bitbar.title>Launch Agents</bitbar.title>
# <bitbar.version>v2.0</bitbar.version>
# <bitbar.author>David O'Trakoun</bitbar.author>
# <bitbar.author.github>davidosomething</bitbar.author.github>
# <bitbar.desc>Based on @rnkn's plugin, shows and manages user Launch Agents.</bitbar.desc>
# <bitbar.dependencies>bash</bitbar.dependencies>

# BitBar Launch Agents plugin

# =============================================================================

launchctl="$(command -v launchctl)"
defaults="$(command -v defaults)"
open="$(command -v open)"
services=("${HOME}/Library/LaunchAgents/"*.plist)

service_pid() {
  "$launchctl" list | grep "$1\$" | sed -E 's/^([-0-9]+).*([0-9]+).*/\1/'
}

service_status() {
  "$launchctl" list | grep "$1\$" | sed -E 's/^([-0-9]+).*([0-9]+).*/\2/'
}

service_property() {
  "$defaults" read "$1" "$2" 2>/dev/null
}

cmd_universal() {
  local bash="$1"
  local service="$2"
  echo "--Copy Path | bash='${bash}' param1=copy param2=${service} terminal=false"
  echo "--Unload | bash='${bash}' param1=unload param2=${service} terminal=false refresh=true"
  echo "--Reload | bash='${bash}' param1=reload param2=${service} terminal=false refresh=true alternate=true"
}

cmd_label() {
  local string="$1"
  local bash="$2"
  local cmd="$3"
  local label="$4"
  echo "--${string} | bash='${bash}' param1=${cmd} param2=${label} terminal=false refresh=true"
}

cmd_app() {
  local string="$1"
  local app="$2"
  local flags="$3"
  local arg1="$4"
  local arg2="$5"
  echo "--${string} | bash=${app} param1=${flags} param2=${arg1} param3=${arg2} terminal=false"
}

cmd_open() {
  local string="$1"
  local app="$2"
  local arg="$3"
  cmd_app "$string" "$open" "-a" "$app" "$arg"
}

cmd_log() {
  local string="$1"
  local file="$2"
  if [[ -f "$file" ]]; then
    cmd_open "$string" "Console" "$file"
  else
    echo "--${string}"
  fi
}

cmd_logs() {
  local log="$1"
  local errorlog="$2"
  echo "-----"
  cmd_log "Log" "$log"
  cmd_log "Error Log" "$errorlog"
  echo "-----"
}

run_command() {
  [[ $1 == copy ]] && echo -n "${2}" | pbcopy
  [[ $1 == start ]] && "$launchctl" start "$2"
  [[ $1 == stop ]] && "$launchctl" stop "$2"
  [[ $1 == load ]] && "$launchctl" load "$2"
  [[ $1 == unload ]] && "$launchctl" unload "$2"
  [[ $1 == reload ]] && {
    "$launchctl" unload "$2"
    "$launchctl" load "$2"
  }
}
run_command "$1" "$2"

echo "| templateImage=iVBORw0KGgoAAAANSUhEUgAAACAAAAAgCAYAAABzenr0AAAABGdBTUEAALGPC/xhBQAAAAlwSFlzAAAWJQAAFiUBSVIk8AAABCRpVFh0WE1MOmNvbS5hZG9iZS54bXAAAAAAADx4OnhtcG1ldGEgeG1sbnM6eD0iYWRvYmU6bnM6bWV0YS8iIHg6eG1wdGs9IlhNUCBDb3JlIDUuNC4wIj4KICAgPHJkZjpSREYgeG1sbnM6cmRmPSJodHRwOi8vd3d3LnczLm9yZy8xOTk5LzAyLzIyLXJkZi1zeW50YXgtbnMjIj4KICAgICAgPHJkZjpEZXNjcmlwdGlvbiByZGY6YWJvdXQ9IiIKICAgICAgICAgICAgeG1sbnM6dGlmZj0iaHR0cDovL25zLmFkb2JlLmNvbS90aWZmLzEuMC8iCiAgICAgICAgICAgIHhtbG5zOmV4aWY9Imh0dHA6Ly9ucy5hZG9iZS5jb20vZXhpZi8xLjAvIgogICAgICAgICAgICB4bWxuczpkYz0iaHR0cDovL3B1cmwub3JnL2RjL2VsZW1lbnRzLzEuMS8iCiAgICAgICAgICAgIHhtbG5zOnhtcD0iaHR0cDovL25zLmFkb2JlLmNvbS94YXAvMS4wLyI+CiAgICAgICAgIDx0aWZmOlJlc29sdXRpb25Vbml0PjI8L3RpZmY6UmVzb2x1dGlvblVuaXQ+CiAgICAgICAgIDx0aWZmOkNvbXByZXNzaW9uPjU8L3RpZmY6Q29tcHJlc3Npb24+CiAgICAgICAgIDx0aWZmOlhSZXNvbHV0aW9uPjE0NDwvdGlmZjpYUmVzb2x1dGlvbj4KICAgICAgICAgPHRpZmY6T3JpZW50YXRpb24+MTwvdGlmZjpPcmllbnRhdGlvbj4KICAgICAgICAgPHRpZmY6WVJlc29sdXRpb24+MTQ0PC90aWZmOllSZXNvbHV0aW9uPgogICAgICAgICA8ZXhpZjpQaXhlbFhEaW1lbnNpb24+MzI8L2V4aWY6UGl4ZWxYRGltZW5zaW9uPgogICAgICAgICA8ZXhpZjpDb2xvclNwYWNlPjE8L2V4aWY6Q29sb3JTcGFjZT4KICAgICAgICAgPGV4aWY6UGl4ZWxZRGltZW5zaW9uPjMyPC9leGlmOlBpeGVsWURpbWVuc2lvbj4KICAgICAgICAgPGRjOnN1YmplY3Q+CiAgICAgICAgICAgIDxyZGY6U2VxLz4KICAgICAgICAgPC9kYzpzdWJqZWN0PgogICAgICAgICA8eG1wOk1vZGlmeURhdGU+MjAxNzowMToyNiAwMDowMTo1MjwveG1wOk1vZGlmeURhdGU+CiAgICAgICAgIDx4bXA6Q3JlYXRvclRvb2w+UGl4ZWxtYXRvciAzLjY8L3htcDpDcmVhdG9yVG9vbD4KICAgICAgPC9yZGY6RGVzY3JpcHRpb24+CiAgIDwvcmRmOlJERj4KPC94OnhtcG1ldGE+CqqgHc8AAAOHSURBVFgJvZZLqM1RFMav6y15lDzKY2ByBxRl6BqYSKEUMwMpSjIwEHVTJjJhwICidGNoICkDRGJg4jFzu0VR8kgh8n79fvee79r33zmncw5Z9Z299tp7r2+tvdfe/9PV9e9lLC7Ff5cxMI4vWCegbwLnwCD4An5VQPffSDduyqw30r8KqoT2f4KvtTGav5dxhYul6OdBSSzZN/ADSG5r3zl/LSX5dry9BCF3yyVLP61BfK/ZaTqXkLv1x0AIJA5BbGVrAEJbx5Jim4mHCyAE9QotY2kT3HvWLe8kAqtbmQquAB2bUc41RI3aFOAt1kwELYtbncxddA5I4jknq0aksZfnv491DUUy4TkL9chslFR66TAkzdpkP4CP+XFYbUuy6thqDPeBJJLXq/JGAZRzt7FW6fb1KsVs3c4esAa8Ah+BWfeCzWAScI6Pj2hVzN76uQw2AAPKTUL9c74L0O+CZGKm0W11VLWV4/X03A4TWgaUsp5GIpnGwA2gk3LL7EvcarGVQeTctW0Fisc8svvlmfcz4ESvlGTC6Fu9YiVx/MR2GD+RUUeXSPYwmsnV7GNvZ+vLzE+GmbZMeMTsubwBEn0GZh4yHVmI6SeYRq3zSvIT9COjii5G24tAh9XMz2BbCY6DT6DenDIQyQ1em4n0gUhD8p3MKJ1Ev4fdRVvAC5A6aLYTIX/E/LUgUnfbHfT8/YwuBIPAiZOBxGdr/ce004G7Y/G4JkGWxSS5656BdeABCLFr25YVrLgBzNjsk3n1mAymtO2irxhMGeCQsdGPE/0yZcFB9BBKED1brM3PaYjz0DzGtggo+WoO95r8uqW5ik7zuZVAWEj1yI9i31ub47wU6HV0n2rFHWhZzHwuWAUeAp169RJImfkp7LPA6dq4AWYHDMAaUloOIIUyj0U6kLR65tnqI4z5x/N2bZ7kZbAD9A1OGfXWD5vq/yZSHb8GOsxDYubRr6ErB0B2xsCSvbb9IJJ6Sr9p6y70A51IGuJkeAfbYqD0AedJbo2ou2M7QKQtchdNAZLo7EOtVRfe5/kgshUlY7ZPwXoQaZvchWbnaxfHBnETHAKLgJI/kOXLeQl7z9Do8E3qiNz1/vt5Dp4A/7H0gjkgDj2i6Ab1FuwG2hXrKONDhlZ/cv8lmwHeAZ17torjklgTkSUo9q14xWq3BjqWBFE6MKNkV9rLueq5QeWctvTfZDO0T448SOoAAAAASUVORK5CYII="
echo "---"
for service in "${services[@]}"; do
  label="$(service_property "$service" Label)"
  log="$(service_property "$service" StandardOutPath)"
  errorlog="$(service_property "$service" StandardErrorPath)"
  pid="$(service_pid "$label")"
  status="$(service_status "$label")"
  [[ $pid == "-" ]] && pid=-1

  if [[ $pid -eq -1 && $status -eq 0 ]]; then
    echo "${label} | color=#00a4db"
    cmd_universal "$0" "$service"
    cmd_label "Start" "$0" "start" "$label"
    cmd_logs "$log" "$errorlog"
    echo "--Idle"
    echo "--No Errors"
  elif [[ $pid -gt 0 && $status -eq 0 ]]; then
    echo "${label} | color=green"
    cmd_universal "$0" "$service"
    cmd_label "Stop" "$0" "stop" "$label"
    cmd_logs "$log" "$errorlog"
    echo "--Running (${pid})"
    echo "--No Errors"
  elif [[ $status -gt 0 ]]; then
    echo "${label} | color=red"
    cmd_universal "$0" "$service"
    cmd_label "Start" "$0" "start" "$label"
    cmd_logs "$log" "$errorlog"
    echo "--Stopped"
    echo "--Error (${status})"
  else
    echo "${label}"
    echo "--Load | bash='${0}' param1=load param2=${service} terminal=false refresh=true"
    cmd_logs "$log" "$errorlog"
    echo "--Unloaded"
  fi
done
echo "---"
echo "Refresh | refresh=true"
