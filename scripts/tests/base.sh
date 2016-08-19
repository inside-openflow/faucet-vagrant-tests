# Base library for BDD-style tests
# Use the following form:
#
# expect "something to be somewhere" <<'end'
#   test -e /tmp
# end
#
# Input is run in a new bash shell with -e set, so the first failure will
# cause the test to exit rather than continue.
#
# expect "this to fail early" <<'end'
#   echo "you see this"
#   false
#   echo "but not this"
# end

errors=0
tests=0
failfast=""

function expect() {
  local title="$@"
  local logfile=$(mktemp)
  local passed=1
  local test=$(cat)

  let tests+=1

  echo -n "Expect $title: "
  if [[ ( $errors -gt 0 ) && -n "$failfast" ]]; then
    test -f $logfile && rm $logfile
    echo "skipped (fail fast enabled)"
  fi
  $BASH -ve <<< "$test" &> $logfile
  passed=$?

  if [[ $passed = 0 ]]; then
    echo "passed"
  else
    echo "FAILED"
    echo "Command:"
    echo "$test"
    echo "Output ($BASH -ve):"
    cat $logfile
    let errors+=1
  fi
  rm $logfile
  return $passed
}

function expect-priv() {
  local title="$@"
  local logfile=$(mktemp)
  local passed=1
  local test=$(cat)

  let tests+=1

  echo -n "Expect (privileged) $title: "
  sudo $BASH -ve <<< "$test" &> $logfile
  passed=$?

  if [[ $passed = 0 ]]; then
    echo "passed"
  else
    echo "FAILED"
    echo "Command:"
    echo "$test"
    echo "Output ($BASH -ve):"
    cat $logfile
    let errors+=1
  fi
  rm $logfile
  return $passed
}

function test_report() {
  echo ""
  if [[ $errors -gt 0 ]]; then
    echo "$errors tests FAILED out of $tests tests"
  else
    echo "$tests passed"
  fi
  return $errors
}
