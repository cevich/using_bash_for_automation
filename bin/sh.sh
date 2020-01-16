#!/bin/bash

source $(dirname $0)/../lib/lib.sh

for varname in LIB_PATH REPO_PATH SCRIPT_PATH; do
    echo "\$$varname: ${!varname}"
done
