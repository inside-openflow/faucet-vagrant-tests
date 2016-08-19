#!/bin/bash

. $(dirname $(realpath -s $0))/base.sh

expect "this to pass" <<'end'
  true
end

expect "this to fail early" <<'end'
  echo "some output"
  false
  echo "should not see this"
end

expect "support for complex tests" <<'end'
  echo "some output"
  test -e $(dirname $(realpath -s $0))
end

export TEST_ENV=foo
expect "environment variables to be passed" <<'end'
  test "$TEST_ENV" = "foo"
end

test_report
