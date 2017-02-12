#!/usr/bin/env bash

set -e -x

cf login -a api.bosh-lite.com -u admin -p admin --skip-ssl-validation
cf create-org test
cf target -o test
cf create-space test
cf target -o test -s test

cf enable-feature-flag diego_docker
cf enable-feature-flag task_creation