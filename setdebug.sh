cat <<EOF
## set debug if has --debug flag:
if [ \$# -gt 0 ] && [ "\$1" = '--debug' ] ; then
 set -x
fi
EOF
