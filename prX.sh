#!/bin/sh
# author: Nguyen Cong Hai
# created: 2016-07-29
#description: 

:
cat << EOF
prX () {
## FLAGS:
# flags for prX must be supplied right after the word prX, and the rest of the command string follows. 
# optionally one could use '--' to clearly mark the seperation of prX flags from the command string it is supposed to print
# flags meaning:
# --verbose: print the command (if no --dry flag, then execute it, otherwise skip executing it)
# -d|--dryrun|--dry-run : just print the command, not executing it (dry-run mode)
# if first arg is a flag, this flag is for this function 
 while [ \$# -gt 0 ] ; do {
  curArg="\$1" ; shift 1
  case "\${curArg}" in
   -v|--verbose|-n|--dry-run|--dryrun)
    echo "\${@}"
    prXDryFlag='-n'
    ;;
   --) 
    break 
    ;;
   -*) 
    echo "\$(basename \$0).prX(): unrecognized flag for prX: \${curArg}">&2
    exit
    ;;
    *)
     break
     ;;
  esac
 } ; done
 
 if [ -z "\${prXDryFlag}" ] ; then {
  eval "\${@}"
  return
 } ; fi # if prX not invoked in dry-run mode
} # prX
EOF
