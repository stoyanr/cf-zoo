#!/bin/bash -ex

if [ -f .cf_deployed ]; then
  exit 0
fi

bosh -n target 127.0.0.1 lite
bosh login admin admin

wget --progress=dot:giga -c http://bosh.io/d/github.com/cloudfoundry/cf-release -O cf-release.tgz
bosh upload release cf-release.tgz --skip-if-exists

rm -rf release.MF
tar -zxvf cf-release.tgz ./release.MF
VERSION=$(tail release.MF -n 1 | awk '{print $2}')
rm -rf release.MF
VERSION="${VERSION%\'}"
VERSION="${VERSION#\'}"
echo "Using CF version $VERSION ..."

if [ ! -d cf-release ]; then
  git clone https://github.com/cloudfoundry/cf-release
fi

pushd cf-release
  git checkout v$VERSION

  sudo gem install bundler
  sudo ./scripts/generate-bosh-lite-dev-manifest
  sudo chown -R vagrant:vagrant bosh-lite
  cp bosh-lite/deployments/cf.yml /vagrant/deployments/

  bosh -n deploy
popd

touch .cf_deployed
