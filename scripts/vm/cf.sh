#!/usr/bin/env bash

set -e -x

if [ -f .cf_deployed ]; then
  exit 0
fi

bosh -n target 127.0.0.1 lite
bosh login admin admin

if [ ! -d cf-release ]; then
  git clone --recurse-submodules https://github.com/cloudfoundry/cf-release
fi

source versions

pushd cf-release
  git checkout ${CF_SHA}

  sudo gem install bundler
  sudo ./scripts/generate-bosh-lite-dev-manifest
  sudo chown -R vagrant:vagrant bosh-lite/deployments/cf.yml

  cp bosh-lite/deployments/cf.yml /vagrant/deployments/

popd
