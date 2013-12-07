afk() {
  words=('please help me' 'i am so alone' 'i am lonely' 'let me out' 'i must feed' 'it puts the lotion' 'my precious');
  while [ 1 = 1 ]; do
    say "${words[$[ $[ RANDOM % ${#words[@]} ]]]}" -v Whisper -r 2
    sleep 100
  done
}

##
# open current repo's github page in browser
github() {
  local github_url

  if ! git remote -v >/dev/null; then
    return 1
  fi

  # get remotes for fetch
  github_url=$(git remote -v | grep github\.com | grep \(fetch\)$)

  if [ -z "$github_url" ]; then
    echo "A GitHub remote was not found for this repository."
    return 1
  fi

  # look for origin in remotes, use that if found, otherwise use first result
  if [ "echo $github_url | grep '^origin' >/dev/null 2>&1" ]; then
    github_url=$(echo $github_url | grep '^origin')
  else
    github_url=$(echo $github_url | head -n1)
  fi

  github_url=$(echo $github_url | awk '{ print $2 }' | sed 's/git@github\.com:/http:\/\/github\.com\//g')
  open $github_url
}

##
# force reuse of existing mvim window
mvim() {
  if [ -n "$1" ]; then
    $(brew --prefix)/bin/mvim --servername VIM --remote-tab-silent $@
  else
    open -a MacVim
  fi
}
