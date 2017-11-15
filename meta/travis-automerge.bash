#!/bin/bash -e

# check for env vars
: "${encrypted_ea0d6abeb5c4_key:?}"
: "${encrypted_ea0d6abeb5c4_iv:?}"

export GIT_COMMITTER_EMAIL='travis-ci@davidosomething.com'
export GIT_COMMITTER_NAME='Travis CI'

# do full checkout
repo_temp="$(mktemp -d)"
git clone "https://github.com/${GITHUB_REPO}" "$repo_temp"
cd "$repo_temp" || exit 1

# setup deploy key
openssl aes-256-cbc \
  -K "$encrypted_ea0d6abeb5c4_key" \
  -iv "$encrypted_ea0d6abeb5c4_iv" \
  -in ./meta/deploy_key.enc \
  -out ./local/deploy_key -d
eval "$(ssh-agent -s)"  # start the ssh agent
chmod 600 local/deploy_key
ssh-add local/deploy_key

# merge and push to master
git checkout master
git merge --ff-only "$TRAVIS_COMMIT"
git push "git@github.com:${TRAVIS_REPO_SLUG}.git" master
