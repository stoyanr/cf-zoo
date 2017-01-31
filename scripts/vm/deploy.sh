#!/usr/bin/env bash

set -e -x

if [ ! -f .deployed ]; then
  bosh deployment cf-networking-release/bosh-lite/deployments/cf_networking.yml
  bosh -n deploy

  cf login -a api.bosh-lite.com -u admin -p admin --skip-ssl-validation
  cf create-org test
  cf target -o test
  cf create-space test
  cf target -o test -s test

  bosh deployment cf-networking-release/bosh-lite/deployments/diego_cf_networking.yml
  bosh -n deploy

  rm -f cf-release.tgz
  rm -f diego-release.tgz
  rm -f garden-runc-release.tgz
  rm -f cflinuxfs2-rootfs-release.tgz
  rm -f netman-release.tgz

  cf login -a api.bosh-lite.com -u admin -p admin --skip-ssl-validation
  cf enable-feature-flag diego_docker
  cf enable-feature-flag task_creation

  touch .deployed
fi
