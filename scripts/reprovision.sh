#!/bin/bash -e

SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

bosh -d $SCRIPT_DIR/../deployments/cf.yml -n delete deployment cf-warden
bosh -d $SCRIPT_DIR/../deployments/cf-mysql.yml -n delete deployment cf-warden-mysql
bosh -d $SCRIPT_DIR/../deployments/cf.yml -n deploy
bosh -d $SCRIPT_DIR/../deployments/cf-mysql.yml -n deploy

$SCRIPT_DIR/add-route.sh

cf create-org test
cf target -o test
cf create-space test
cf target -o test -s test

