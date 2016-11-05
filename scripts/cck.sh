#!/bin/bash -e

SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

bosh -d $SCRIPT_DIR/../deployments/cf.yml cck
bosh -d $SCRIPT_DIR/../deployments/cf-mysql.yml cck
