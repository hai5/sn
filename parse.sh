#!/bin/sh
# author: Nguyen Cong Hai
# created: 2016-07-29

cat <<EOF
## parsing args:
ops="\$1" ; shift 1
case "\$ops" in
  *) sed -n '/parsing args:/,/\<esac\>/p' "\${BASH_SOURCE}" | grep '\-\-' ;;
esac
EOF
