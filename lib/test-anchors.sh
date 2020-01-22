#!/bin/bash

# Unit-tests for library script in the current directory
# Also verifies test script is derived from library filename
TEST_FILENAME=$(basename $0)  # prefix-replace needs this in a variable
SUBJ_FILENAME="${TEST_FILENAME#test-}"; unset TEST_FILENAME
TEST_DIR=$(dirname $0)/

ANY_FAILED=0
# Print text after executing command, set ANY_FAILED non-zero on failure
# usage: test_cmd "description" <command> [arg...]
test_cmd() {
    local text="${1:-no test text given}"
    shift
    if ! "$@"; then
       echo "fail - $text"; ANY_FAILED=1;
    else
        echo "pass - $text"
    fi
}

test_paths() {
    source $TEST_DIR/$SUBJ_FILENAME
    test_cmd "Library $SUBJ_FILENAME is not executable" \
        test ! -x "$SCRIPT_PATH/$SUBJ_FILENAME"
    test_cmd "The unit-test and library files in same directory" \
        test "$LIB_PATH" == "$SCRIPT_PATH"
    for path_var in LIB_PATH REPO_PATH SCRIPT_PATH; do
        test_cmd "\$$path_var is defined and non-empty: ${!path_var}" \
            test -n "${!path_var}"
        test_cmd "\$$path_var referrs to existing directory" \
            test -d "${!path_var}"
    done
}

# CI must only/always be either 'true' or 'false'.
# Usage: test_ci <initial value> <expected value>
test_ci() {
    local prev_CI="$CI"
    CI="$1"
    source $TEST_DIR/$SUBJ_FILENAME
    test_cmd "Library $SUBJ_FILENAME loaded from $TEST_DIR" \
        test "$?" -eq 0
    test_cmd "\$CI='$1' becomes 'true' or 'false'" \
        test "$CI" = "true" -o "$CI" = "false"
    test_cmd "\$CI value '$2' was expected" \
        test "$CI" = "$2"
    CI="$prev_CI"
}

test_paths
test_ci "" "false"
test_ci "$RANDOM" "true"
test_ci "FoObAr" "true"
test_ci "false" "false"
test_ci "true" "true"

# Always run all tests and report, exit non-zero if any failed
test_cmd "All tests passed" \
    test "$ANY_FAILED" -eq 0
[[ "$CI" == "false" ]] || exit $ANY_FAILED  # useful to automation
