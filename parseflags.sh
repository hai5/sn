#!/usr/bin/env bash
# author: Cong Hai Nguyen ; created: 2016-09-03 
# version: 0.0.1
# license: GNU GPL-v3 (https://www.gnu.org/licenses/gpl-3.0.txt)
# dependencies: 
# description: 

cat <<EOF
# collect flags:
flags=''
operands=''

while [ \$# -gt 0 ] ; do
 curarg="\$1" ; shift 1
 case "\${curarg}" in
  -*) flags="\${flags} \$curarg" ;;
  *) operands="\${operands} \"\${curarg}\""
 esac
done
eval set -- "\$operands"
EOF
