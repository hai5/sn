prx () {
  if [ -n "$IS_DRY_RUN" ] ; then {
   echo "$*"
   return
  } ; fi # if prX not invoked in dry-run mode
 
  eval ""
  return
} # prX
