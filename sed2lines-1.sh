#!/usr/bin/env bash
. "$(dirname "${BASH_SOURCE}")"/sed2lines
cat <<EOF 
 | grep -E '[ \t]+[^ \t\n*]+\)'
EOF
