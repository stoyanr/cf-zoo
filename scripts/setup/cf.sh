#!/usr/bin/env bash

set -e -x

if [ -f .deployed ]; then
  exit 0
fi

source versions

wget --progress=dot:giga -c https://bosh.io/d/github.com/cloudfoundry/cf-release?v=${CF_VERSION} -O cf-release.tgz

bosh -n target 127.0.0.1 lite
bosh login admin admin
bosh upload release cf-release.tgz --skip-if-exists

if [ ! -d cf-release ]; then
  git clone https://github.com/cloudfoundry/cf-release
fi

pushd cf-release
  git checkout v${CF_VERSION}
  sudo gem install bundler
popd
