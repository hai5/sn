#!/usr/bin/env bash
# author: Cong Hai Nguyen ; created: 2016-09-04 
# version: 0.0.1
# license: GNU GPL-v3 (https://www.gnu.org/licenses/gpl-3.0.txt)
# dependencies: 
# description: parse the flags into seperate operations (UNCHAINing the flag into individual lines)

cat <<EOF  
## parse the flags into seperate operations (UNCHAINing the flag into individual lines):
printf "%q\n" "\$*" | awk 'BEGIN { RS="[ \t]+[-]{1,2}"} {print}' | while IFS= read -r line ; do
## <<some-code-here>>
done
EOF
