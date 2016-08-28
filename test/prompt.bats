#!/usr/bin/env bats

load '../vendor/bats-support/load'
load '../vendor/bats-assert/load'
load 'test_helper'

@test "prompt: is shown when commit has validation warnings" {
  echo "n" > $FAKE_TTY
  run git commit -m " Add foo bar string to my_file"

  assert_failure
  assert_line --partial "Proceed with commit? [e/y/n/?]"
}

@test "prompt: e opens the editor" {
  skip # skip this until I can find a way to solve the interaction loop
  echo "e" > $FAKE_TTY
  run git commit -m "Oops"
}

@test "prompt: y proceeds with commit" {
  echo "y" > $FAKE_TTY
  run git commit -m "Oops"

  assert_success
  assert_line --partial "1 file changed, 1 insertion(+)"
}

@test "prompt: n aborts commit" {
  echo "n" > $FAKE_TTY
  run git commit -m "Oops"

  assert_failure
  refute_line --partial "1 file changed, 1 insertion(+)"
}

@test "prompt: ? shows help" {
  skip # skip this until I can find a way to solve the interaction loop
  echo "?" > $FAKE_TTY
  run git commit -m "Oops"

  assert_line "e - edit commit message"
}

@test "prompt: default shows help" {
  skip # skip this until I can find a way to solve the interaction loop
  echo "FOO" > $FAKE_TTY
  run git commit -m "Oops"

  assert_line "e - edit commit message"
}
