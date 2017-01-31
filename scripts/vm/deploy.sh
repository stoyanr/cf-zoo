#!/usr/bin/env bash

set -e -x

###
### CF
###
if [ ! -f .cf_deployed ]; then
  pushd cf-release
    bosh deployment bosh-lite/deployments/cf.yml
    bosh -n create release --force &&
    bosh -n upload release &&
    bosh -n deploy
  popd

  rm -rf cf-release.tgz

  cf login -a api.bosh-lite.com -u admin -p admin --skip-ssl-validation
  cf create-org test
  cf target -o test
  cf create-space test
  cf target -o test -s test

  touch .cf_deployed
fi

###
### Diego
###
if [ ! -f .diego_deployed ]; then
  pushd diego-release
    bosh -d bosh-lite/deployments/diego.yml -n deploy
  popd

  rm -f diego-release.tgz
  rm -f garden-runc-release.tgz
  rm -f cflinuxfs2-rootfs-release.tgz

  cf login -a api.bosh-lite.com -u admin -p admin --skip-ssl-validation
  cf enable-feature-flag diego_docker
  cf enable-feature-flag task_creation

  touch .diego_deployed
fi

###
### Netman
###
if [ ! -f .netman_deployed ]; then
  pushd cf-networking-release
    bosh -d bosh-lite/deployments/cf_networking.yml -n deploy
    bosh -d bosh-lite/deployments/diego_cf_networking.yml -n deploy
  popd

  rm -rf netman-release.tgz

  touch .netman_deployed
fi