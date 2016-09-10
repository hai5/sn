#!/usr/bin/env bash
expandSnip sed2lines.sh
printf "%s" "| sed -n '/-.*)/p' "
