#!/usr/bin/env bash
printf "sed -n '/\<case\>/,/\<esac\>/p' \"\${BASH_SOURCE}\" | grep '[[:space:]]\\-[^(]+\\)'"
