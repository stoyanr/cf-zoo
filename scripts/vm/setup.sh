#!/usr/bin/env bash

set -e -x

bosh -u admin -p admin target localhost lite
bosh login admin admin

bosh -d cf-networking-release/bosh-lite/deployments/cf_networking.yml -n deploy --recreate
bosh -d cf-networking-release/bosh-lite/deployments/diego_cf_networking.yml -n deploy --recreate
bosh -d cf-mysql-release/cf-mysql.yml -n deploy --recreate

cf login -a api.bosh-lite.com -u admin -p admin --skip-ssl-validation
cf create-org test
cf target -o test
cf create-space test
cf target -o test -s test

cf enable-feature-flag diego_docker
cf enable-feature-flag task_creation