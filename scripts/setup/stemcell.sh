#!/usr/bin/env bash

set -e -x

if [ -f .stemcell_uploaded ]; then
  exit 0
fi

bosh -n target 127.0.0.1 lite
bosh login admin admin

wget --progress=dot:giga -c https://bosh.io/d/stemcells/bosh-warden-boshlite-ubuntu-trusty-go_agent -O bosh-warden-boshlite-ubuntu-trusty-go_agent.tgz
bosh upload stemcell bosh-warden-boshlite-ubuntu-trusty-go_agent.tgz --skip-if-exists
rm -rf bosh-warden-boshlite-ubuntu-trusty-go_agent.tgz

touch .stemcell_uploaded
