#!/bin/bash -e

SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

bosh -d $SCRIPT_DIR/../deployments/cf.yml -n delete deployment --force cf-warden
bosh -d $SCRIPT_DIR/../deployments/diego.yml -n delete deployment --force cf-warden-diego
bosh -d $SCRIPT_DIR/../deployments/cf-mysql.yml -n delete deployment --force cf-warden-mysql

bosh -d $SCRIPT_DIR/../deployments/cf.yml -n deploy
bosh -d $SCRIPT_DIR/../deployments/diego.yml -n deploy
bosh -d $SCRIPT_DIR/../deployments/cf-mysql.yml -n deploy

$SCRIPT_DIR/add-route.sh

cf login -a api.bosh-lite.com -u admin -p admin --skip-ssl-validation
cf create-org test
cf target -o test
cf create-space test
cf target -o test -s test

cf enable-feature-flag diego_docker