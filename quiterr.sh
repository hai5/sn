#!/bin/sh
#author: Nguyen Cong Hai
#created: 2016-07-05

cat << EOF
quitErr {
 # perform some steps prior to quit with error:
 # echo "sn: \$*. Filetypes so far: \${gbSnipArr}" >&2
 echo "sn: \$*" >&2 
 shift 1
 if [ \$# -gt 0 ] ; then
     exit "\$1"
 else
  exit 1
 fi
} # quitErr
EOF
