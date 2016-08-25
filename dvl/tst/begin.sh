#!/bin/bash
#author: Nguyen Cong Hai
#created: 2016-07-05
#description:

cat << EOF
PROGNAME="\$(basename \${0})"

# string to print when user calls with --help flag:
Usage="\${PROGNAME}: to be documented"
EOF
