#!/usr/bin/env bash

set -e -x

if [ -f .diego_deployed ]; then
  exit 0
fi

bosh -n target 127.0.0.1 lite
bosh login admin admin

source versions

wget --progress=dot:giga -c "http://bosh.io/d/github.com/cloudfoundry/diego-release?v=$DIEGO_VERSION" -O diego-release.tgz
bosh upload release diego-release.tgz --skip-if-exists

wget --progress=dot:giga -c "http://bosh.io/d/github.com/cloudfoundry/garden-runc-release?v=$GARDEN_VERSION" -O garden-runc-release.tgz
bosh upload release garden-runc-release.tgz --skip-if-exists

wget --progress=dot:giga -c "http://bosh.io/d/github.com/cloudfoundry/cflinuxfs2-rootfs-release?v=$CFLINUX_VERSION" -O cflinuxfs2-rootfs-release.tgz
bosh upload release cflinuxfs2-rootfs-release.tgz --skip-if-exists

if [ ! -d diego-release ]; then
  git clone https://github.com/cloudfoundry/diego-release.git
fi

pushd diego-release
  git checkout v${DIEGO_VERSION}

  echo "Co-locating Diego on a single VM ..."
  cp manifest-generation/bosh-lite-stubs/colocated-instance-count-overrides.yml manifest-generation/bosh-lite-stubs/instance-count-overrides.yml

  sudo SQL_FLAVOR='postgres' ./scripts/generate-bosh-lite-manifests
  sudo chown -R vagrant:vagrant bosh-lite
  cp bosh-lite/deployments/diego.yml /vagrant/deployments/
  cp bosh-lite/deployments/diego-benchmarks.yml /vagrant/deployments/
  cp bosh-lite/deployments/vizzini.yml /vagrant/deployments/
popd
