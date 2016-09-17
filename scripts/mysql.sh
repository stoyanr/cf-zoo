#!/bin/bash -ex

if [ -f .mysql_deployed ]; then
  exit 0
fi

bosh -n target 127.0.0.1 lite
bosh login admin admin

wget --progress=dot:giga -c http://bosh.io/d/github.com/cloudfoundry/cf-mysql-release -O mysql-release.tgz
bosh upload release mysql-release.tgz --skip-if-exists

rm -rf release.MF
tar -zxvf mysql-release.tgz ./release.MF
VERSION=$(tail release.MF -n 1 | awk '{print $2}')
rm -rf release.MF
VERSION="${VERSION%\'}"
VERSION="${VERSION#\'}"
echo "Using CF version $VERSION ..."

if [ ! -d cf-mysql-release ]; then
  git clone https://github.com/cloudfoundry/cf-mysql-release.git
fi

pushd cf-mysql-release
  git checkout v$VERSION

  sudo gem install bundler
  sudo ./scripts/generate-bosh-lite-manifest

  bosh -n deploy

  bosh run errand broker-registrar
  bosh run errand acceptance-tests
popd

touch .mysql_deployed

