#!/bin/bash -e

echo "==> Checking env vars"
: "${TRAVIS_COMMIT:?}"
: "${TRAVIS_REPO_SLUG:?}"
: "${encrypted_6115b2a51146_key:?}"
: "${encrypted_6115b2a51146_iv:?}"

echo "==> Setup deploy key"
openssl aes-256-cbc \
  -K "$encrypted_6115b2a51146_key" \
  -iv "$encrypted_6115b2a51146_iv" \
  -in ./meta/deploy_key.enc \
  -out ./local/deploy_key -d
eval "$(ssh-agent -s)"  # start the ssh agent
chmod 600 local/deploy_key
ssh-add local/deploy_key

echo "==> Cloning full repo"
repo_temp="$(mktemp -d)"
git clone "git@github.com:${TRAVIS_REPO_SLUG}.git" "$repo_temp"
cd "$repo_temp" || exit 1

echo "==> Merge into master and push"
export GIT_COMMITTER_EMAIL='travis-ci@davidosomething.com'
export GIT_COMMITTER_NAME='Travis CI'
git checkout master
git merge --ff-only "$TRAVIS_COMMIT"
git push origin master
