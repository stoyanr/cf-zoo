#!/bin/bash -ex

if [ ! -f .apt-get-updated ]; then
  apt-get -y update
  apt-get -y install vim nano curl git wget unzip
  touch .apt-get-updated
fi

if [ ! -f /usr/local/bin/spiff ]; then
  wget --progress=dot:mega -c https://github.com/cloudfoundry-incubator/spiff/releases/download/v1.0.7/spiff_linux_amd64.zip
  unzip spiff_linux_amd64.zip -d /usr/local/bin
  rm spiff_linux_amd64.zip
fi

