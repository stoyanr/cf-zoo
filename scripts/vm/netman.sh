#!/usr/bin/env bash

set -e -x

if [ -f .deployed ]; then
  exit 0
fi

source versions

if [ ! -d cf-networking-release ]; then
  git clone https://github.com/cloudfoundry-incubator/cf-networking-release
fi

pushd cf-networking-release
  git checkout v${NETMAN_VERSION}

  bosh upload release releases/cf-networking/cf-networking-${NETMAN_VERSION}.yml

  sudo ./scripts/generate-bosh-lite-manifests
  sudo chown -R vagrant:vagrant bosh-lite

  cp bosh-lite/deployments/cf_networking.yml /vagrant/deployments/
  cp bosh-lite/deployments/diego_cf_networking.yml /vagrant/deployments/
popd
