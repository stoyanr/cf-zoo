#!/usr/bin/env bash

set -e -x

if [ -f .mysql_deployed ]; then
  exit 0
fi

bosh -n target 127.0.0.1 lite
bosh login admin admin

wget --progress=dot:giga -c http://bosh.io/d/github.com/cloudfoundry/cf-mysql-release -O mysql-release.tgz
bosh upload release mysql-release.tgz --skip-if-exists

rm -rf release.MF
tar -zxvf mysql-release.tgz ./release.MF
VERSION=$(cat release.MF | awk '{if (NR == 2) {print $2}}')
rm -rf release.MF
VERSION="${VERSION//\"/}"
echo "Using MySQL release version $VERSION ..."

if [ ! -d cf-mysql-release ]; then
  git clone https://github.com/cloudfoundry/cf-mysql-release.git
fi

pushd cf-mysql-release
  git checkout v$VERSION

  sudo gem install bundler
  sudo ./scripts/generate-bosh-lite-manifest
  cp cf-mysql.yml /vagrant/deployments/

  bosh -n deploy --no-redact

  bosh run errand broker-registrar
  bosh run errand smoke-tests
popd

rm -rf mysql-release.tgz

touch .mysql_deployed

