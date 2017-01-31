#!/usr/bin/env bash

set -e -x

if [ -f .netman_deployed ]; then
  exit 0
fi

wget --progress=dot:giga -c "http://bosh.io/d/github.com/cloudfoundry-incubator/netman-release?v=$NETMAN_VERSION" -O netman-release.tgz
bosh upload release netman-release.tgz --skip-if-exists

if [ ! -d cf-networking-release ]; then
  git clone https://github.com/cloudfoundry-incubator/cf-networking-release
fi

pushd cf-networking-release
  ./scripts/generate-bosh-lite-manifests
  cp bosh-lite/deployments/diego.yml /vagrant/deployments/
popd
