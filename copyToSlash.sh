# author: Cong Hai Nguyen ; created: 2016-08-27 ; version: 0.0.1
# license: GNU GPL-v3 (https://www.gnu.org/licenses/gpl-3.0.txt)
# description: 

cat <<EOF 
copyToSlash () {
 ! [ -f "\$*".orig ] && cp "\$*" "\$*".orig
 cp "\${LOCAL_SLASH_DIR}\${SOURCE_LIST_FILE}" "\${SOURCE_LIST_FILE}"
} # copyToSlash
EOF
