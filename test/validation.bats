#!/usr/bin/env bats

load ../vendor/bats-support/load
load ../vendor/bats-assert/load
load test_helper

@test "validation: ignores empty commits" {
  echo "n" > $FAKE_TTY
  run git commit -m ''

  assert_failure
  assert_line --partial 'Aborting commit'
}

@test "validation: ignores comments" {
  echo "n" > $FAKE_TTY
  run git commit -m "$(cat <<EOF
# a commented line
Add foo bar string to my_file
# another commented line in the body that runs to longer than 72 characters
EOF
)"

  assert_success
}

@test "validation: ignores commits with the fixup! autosquash flag" {
  echo "n" > $FAKE_TTY
  run git commit -m "$(cat <<EOF
fixup! Add foo bar string to my_file - As requested by Jon
Another line in the body that runs to longer than 72 characters in length
EOF
)"

  assert_success
}

@test "validation: ignores lines after the verbose cut line" {
  echo "n" > $FAKE_TTY
  run git commit -m "$(cat <<EOF
Add foo bar string to my_file

# ------------------------ >8 ------------------------
A line in the body that runs to longer than 72 characters after the verbose cut line
EOF
)"

  assert_success
}


# 0. Good commits - control
# ------------------------------------------------------------------------------

@test "validation: a 'good' single line message does not show warnings" {
  echo "n" > $FAKE_TTY
  run git commit -m "Add foo bar string to my_file"

  assert_success
}

@test "validation: a 'good' multi line message does not show warnings" {
  echo "n" > $FAKE_TTY
  run git commit -m "$(cat <<EOF
Summarize change in around 50 characters or less

More detailed explanatory text, if necessary. Wrap it to about 72
characters or so. In some contexts, the first line is treated as the
subject of the commit and the rest of the text as the body. The
blank line separating the summary from the body is critical (unless
you omit the body entirely); various tools like `log`, `shortlog`
and `rebase` can get confused if you run the two together.

Explain the problem that this commit is solving. Focus on why you
are making this change as opposed to how (the code explains that).
Are there side effects or other unintuitive consequences of this
change? This is the place to explain them.

Further paragraphs come after blank lines.

 - Bullet points are okay, too

 - Typically a hyphen or asterisk is used for the bullet, preceded
   by a single space, with blank lines in between, but conventions
   vary here

If you use an issue tracker, put references to them at the bottom,
like this:

Resolves: #123
See also: #456, #789
EOF
)"

  assert_success
}

# 1. Separate subject from body with a blank line
# ------------------------------------------------------------------------------

@test "validation: message without a blank line between subject and body shows warning" {
  echo "n" > $FAKE_TTY
  run git commit -m "$(cat <<EOF
Add foo bar string to my_file
Requested by John @ ACME corp.
EOF
)"

  assert_failure
  assert_line --partial "Separate subject from body with a blank line"
}

# 2. Limit the subject line to 50 characters
# ------------------------------------------------------------------------------

@test "validation: subject line more than 50 chars shows warning" {
  echo "n" > $FAKE_TTY
  run git commit -m "Add foo bar string to my_file - As requested by Jon"

  assert_failure
  assert_line --partial "Limit the subject line to 50 characters (51 chars)"
}

@test "validation: ignores squash! prefix when checking subject line length" {
  echo "n" > $FAKE_TTY
  run git commit -m "squash! Add foo bar string to my_file - As requested by Jo"

  assert_success
  refute_line --partial "Limit the subject line to 50 characters"
}

# 3. Capitalize the subject line
# ------------------------------------------------------------------------------

@test "validation: subject line starting with lowercase word shows warning" {
  echo "n" > $FAKE_TTY
  run git commit -m "add foo bar string to my_file"

  assert_failure
  assert_line --partial "Capitalize the subject line"
}

@test "validation: subject line starting with with uppercase word shows warning" {
  echo "n" > $FAKE_TTY
  run git commit -m "ADD foo bar string to my_file"

  assert_failure
  assert_line --partial "Capitalize the subject line"
}

@test "validation: subject line starting with a symbol shows warning" {
  echo "n" > $FAKE_TTY
  run git commit -m "- Add foo bar string to my_file"

  assert_failure
  assert_line --partial "Capitalize the subject line"
}

@test "validation: subject line starting with a number does not show a warning" {
  echo "n" > $FAKE_TTY
  run git commit -m "5014 - Add foo bar string to my_file"

  assert_success
  refute_line --partial "Capitalize the subject line"
}

@test "validation: ignores squash! prefix when checking subject line capitalisation" {
  echo "n" > $FAKE_TTY
  run git commit -m "squash! Add foo bar string to my_file"

  assert_success
  refute_line --partial "Capitalize the subject line"
}

# 4. Do not end the subject line with a period
# ------------------------------------------------------------------------------

@test "validation: subject line ending with a period shows warning" {
  echo "n" > $FAKE_TTY
  run git commit -m "Add foo bar string to my_file."

  assert_failure
  assert_line --partial "Do not end the subject line with a period"
}

# 5. Use the imperative mood in the subject line
# ------------------------------------------------------------------------------

@test "validation: subject line starting with 'fixes' shows warning" {
  echo "n" > $FAKE_TTY
  run git commit -m "Fixes for broken stuff"

  assert_failure
  assert_line --partial "Use the imperative mood in the subject line"
}

@test "validation: subject line starting with 'fixed' shows warning" {
  echo "n" > $FAKE_TTY
  run git commit -m "Fixed bug with Y"

  assert_failure
  assert_line --partial "Use the imperative mood in the subject line"
}

@test "validation: subject line starting with 'fixing' shows warning" {
  echo "n" > $FAKE_TTY
  run git commit -m "Fixing behavior of X"

  assert_failure
  assert_line --partial "Use the imperative mood in the subject line"
}

@test "validation: subject line in imperative mood with 'fixes' does not show warning" {
  echo "n" > $FAKE_TTY
  run git commit -m "Remove the temporary fixes to Y"

  assert_success
  refute_line --partial "Use the imperative mood in the subject line"
}

@test "validation: body with 'fixes', 'fixed', 'fixing' does not show warning" {
  run git commit -m "$(cat <<EOF
Add foo bar string to my_file

This has been done to avoid fixing Y, and has also fixed X.

Fixes: #Z
EOF
)"

  assert_success
  refute_line --partial "Use the imperative mood in the subject line"
}

# 6. Wrap the body at 72 characters
# ------------------------------------------------------------------------------

@test "validation: body with lines more than 72 chars shows warning" {
  echo "n" > $FAKE_TTY
  run git commit -m "$(cat <<EOF
Add foo bar string to my_file

Requested by John @ ACME corp in order to resolve issue affecting client in
production.

This change may also resolve the intermittent issue client X been seeing on Y.

See Z.
EOF
)"

  assert_failure
  assert_line --partial "Wrap the body at 72 characters (75 chars)"
  assert_line --partial "Wrap the body at 72 characters (78 chars)"
}

@test "validation: body with URLs longer than 72 chars does not show warning" {
  run git commit -m "$(cat <<EOF
Add foo bar string to my_file

 - Added string direcly to avoid issues with X, ref:
   http://www.example.com/a-link-to-a-relevant-article-or-issue-or-discussion-thread

Fixes: #Y.
EOF
)"

  assert_success
  refute_line --partial "Wrap the body at 72 characters"
}

# 7. Use the body to explain what and why vs. how
# ------------------------------------------------------------------------------

# ?

# 8. Do no write single worded commits
# ------------------------------------------------------------------------------

@test "validation: subject line with less than 2 words shows warning" {
  echo "n" > $FAKE_TTY
  run git commit -m "Quickfix"

  assert_failure
  assert_line --partial "Do no write single worded commits"
}

# 9. Do not start the subject line with whitespace
# ------------------------------------------------------------------------------

@test "validation: subject line starting with whitespace shows warning" {
  echo "n" > $FAKE_TTY
  run git commit -m " Add foo bar string to my_file"

  assert_failure
  assert_line --partial "Do not start the subject line with whitespace"
}

