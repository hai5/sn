#!/bin/bash
cmd="bashdb -x "${BASH_SOURCE}.bashdb" "$(echo "${BASH_SOURCE}" | sed -e 's/^debug-\([^-]\+\)-.*$/\1/')".sh separator markdown"
echo "$cmd"
eval "$cmd"
