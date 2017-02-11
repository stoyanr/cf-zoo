#!/usr/bin/env bash

set -e -x

if [ -f .app_pushed ]; then
  exit 0
fi

if [ ! -d cf-sample-app-nodejs ]; then
  git clone https://github.com/cloudfoundry-samples/cf-sample-app-nodejs.git
fi

pushd cf-sample-app-nodejs
  cf push
popd

touch .app_pushed