#!/usr/bin/env bash

set -e

SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

bosh -d $SCRIPT_DIR/../deployments/cf_networking.yml -n deploy --recreate
bosh -d $SCRIPT_DIR/../deployments/diego_cf_networking.yml -n deploy --recreate
bosh -d $SCRIPT_DIR/../deployments/cf-mysql.yml -n deploy --recreate

$SCRIPT_DIR/add-route.sh

cf login -a api.bosh-lite.com -u admin -p admin --skip-ssl-validation
cf create-org test
cf target -o test
cf create-space test
cf target -o test -s test

cf enable-feature-flag diego_docker
cf enable-feature-flag task_creation
