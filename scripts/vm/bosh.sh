#!/usr/bin/env bash

set -e -x

bosh -u admin -p admin target localhost lite
bosh login admin admin

bosh -n delete deployment --force cf-mysql
bosh -n delete deployment --force cf-warden
bosh -n delete deployment --force cf-warden-diego

bosh -d cf-networking-release/bosh-lite/deployments/cf_networking.yml -n deploy --no-redact
bosh -d cf-networking-release/bosh-lite/deployments/diego_cf_networking.yml -n deploy --no-redact
bosh -d cf-mysql-release/cf-mysql.yml -n deploy --no-redact
