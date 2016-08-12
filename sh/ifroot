#!/bin/sh
cat  << EOF
if [ "\$(whoami)" != 'root' ] ; then {
 echo "\$(basename \$0): ERROR: need to be root" >&2
 exit 1
} ; fi
EOF
