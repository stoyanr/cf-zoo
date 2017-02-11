#!/usr/bin/env bash

set -e

SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

if [ "$1" == "setup" ]; then
  cp $SCRIPT_DIR/../Vagrantfile.setup $SCRIPT_DIR/../Vagrantfile
else
  cp $SCRIPT_DIR/../Vagrantfile.up $SCRIPT_DIR/../Vagrantfile
fi
