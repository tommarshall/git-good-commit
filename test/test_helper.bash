# !/usr/bin/env bash

# Set up stubs for faking TTY input
export FAKE_TTY="$BATS_TMPDIR/fake_tty"
function tty() { echo $FAKE_TTY; }
export -f tty

# Remember where the hook is
BASE_DIR=$(dirname $BATS_TEST_DIRNAME)
# Set up a directory for our git repo
TMP_DIRECTORY=$(mktemp -d)

setup() {
  # Clear initial TTY input
  > $FAKE_TTY

  # Set up a git repo
  cd $TMP_DIRECTORY
  mkdir templates
  git -c "init.templatedir=$TMP_DIRECTORY/templates" init
  git config user.email "test@git-good-commit"
  git config user.name "Git Good Commit Tests"
  echo "Foo bar" > my_file
  git add my_file
  mkdir -p .git/hooks
  cp "$BASE_DIR/hook.sh" .git/hooks/commit-msg
}

teardown() {
  if [ $BATS_TEST_COMPLETED ]; then
    echo "Deleting $TMP_DIRECTORY"
    rm -rf $TMP_DIRECTORY
  else
    echo "** Did not delete $TMP_DIRECTORY, as test failed **"
  fi

  cd $BATS_TEST_DIRNAME
}
