#!/bin/bash
# author: Nguyen Cong Hai
# created: 2016-08-01
# version: 0.0.1

expandSnip header.sh
cat <<EOF
set -o errexit
set -o pipefail

. ~/lib/libparsedebug.sh

_quitErr () {
  . ~/lib/libquiterr.sh
}
EOF
