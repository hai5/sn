#!/usr/bin/env bash
# author: Cong Hai Nguyen ; created: 2016-09-04 
# version: 0.0.1
# license: GNU GPL-v3 (https://www.gnu.org/licenses/gpl-3.0.txt)
# dependencies: 
# description: 

cat <<EOF
  sed -e '0,/^[ \t]*$/ s#^[ \t]*$#<<your_text>>#' <<filename>> # search from line 0 to first occurence of blank line , then replace the blank line with the word ONCE
EOF
