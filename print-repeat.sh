#!/bin/bash
#author: Nguyen Cong Hai
#created: 2016-07-05
#description: print a single char repeatedly

# if CHAR not yet defined:
if [ -z ${CHAR+x} ] ; then {
 CHAR=";;"
} ; fi

cat << EOF
printf %10s |tr " " "${CHAR}"
EOF
