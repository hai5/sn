#!/usr/bin/env bash
expandSnip sed2lines.sh
printf "%s" '| grep -E "'"[ \t]+[^ \t\n*]+\)"'"'
