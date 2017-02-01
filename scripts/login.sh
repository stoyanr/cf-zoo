#!/usr/bin/env bash

set -e

SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

$SCRIPT_DIR/add-route.sh

echo "Logging to BOSH-Lite CF ..." 
cf login -a api.bosh-lite.com -u admin -p admin --skip-ssl-validation 
