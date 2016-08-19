#!/bin/bash
# author: Nguyen Cong Hai
# created: 2016-08-01
# version: 0.0.6
# description:
#  features:
#   transform parent's snippets into child snippet via transform function in .parent file

# ========================= VARIABLES =========================
readonly PROGNAME="$(basename "${0}")"
readonly ERR="${PROGNAME}: ERROR:" #convenience string

readonly BASEDIR="$(readlink -e "$(dirname ${BASH_SOURCE})")" # the dir name to be used to find the snippet file
readonly PARENT_FILENAME=".parent" # holding 1 line which is the name of the parent filetype
readonly BASE_FILETYPE="_base"
readonly DEFAULT_MAX_LOOPCOUNT=10 # prevent infinite loop
gbParentsArray="" # array of parent filetypes come across while searching parent tree for the snippet file. This will be reset each time expandSnip is called

# usage string:
Usage="$PROGNAME: print out the snippet content
Syntax: $PROGNAME <snippet-name> <file-type> [extra-arguments ...]
"
## ========================= FUNCTIONS =========================
V () {
 # purpose: to setup variable put inside <filetype>/<VARNAME>.arg
 # syntax: includeVar
 # args external: gbParentsArray # set by the expandSnip function. So some expandSnip function should be run first before running this function

# ========== VALIDATION ==========  
for i in gbParentsArray ; do {
 
 #XXX: cannot use if (eval "[-z ...") -> incorrect result (don't know why yet):
 eval "if [ -z \"\${$i+x}\" ] ; then echo \"ERROR: variable undefined: $i\" >&2 ; exit 1; fi"
 # eval "[ -z \"\$${i}\" ]" ; imm_retval=$?
 eval "if [ -z \"\$$i\" ] ; then echo \"ERROR: variable is empty string: $i\" >&2 ; exit 1; fi"
} ; done
 
 # ## assert that varNameArray and varValArray are of the same size:
 # if [ ${#varNameArray[@]} -ne ${#varValArray[@]} ] ; then {
 #  printf "$(basename $0):ERROR: arrays not of the same size: varNameArray(${#varNameArray[@]}) -ne varValArray(${#varValArray[@]}):\n
 #  varNameArray: ${varNameArray[@]}
 #  varValArray: ${varValArray[@]}
 #  " >&2 
 #  exit 1
 # } ; fi
 
# ========== MAIN ==========  
 gbParentsArraySize=${#gbParentsArray[@]} # for note on gbParentsArray, see args external note just above
 
 ## set variables if there is a <filetype>/<VARIABLE_NAME>.arg file
# for i in seq 0 ${#varNameArray[@]} ; do {
 # curVarName="${varNameArray[$i]}" # current variable name to search for definition file 
for i in ${@} ; do {
 curVarName="${i}" # current variable name to search for definition file 
 
 ## traverse the parent tree to find a file named <variable-name>.arg:
 for counter in $(seq 0 $(($gbParentsArraySize-1))) ; do {
  curFile="${BASEDIR}/${gbParentsArray[$counter]}/${curVarName}.arg"   # current filename to process
  test -f "${curFile}" && eval "${curVarName}=\"$(cat "${curFile}")\"" && break
 } ; done
 
# variables not set by the curFile loop above should be set by default values in _base (via the _base/<var-name>.arg file)
## set variable if not set by the curFile loop above:
 # curVarValue="${varValArray[$i]}"
 # eval "test -z \${${curVarName}+x} &&  ${curVarName}=\"${varValArray[$i]}\""
} ;done
# for i in ${@} ; do eval "echo $i=\$${i}" ; done
} # setVars

expandSnip () {
 # ensure setVars must have been defined already (setVars definition should have been defined before this function), as snippet's code will need that function to run:
 if !(type -t setVars | grep -q 'function') ; then {
  echo "ERROR: function setVars has not been loaded before this functionis called."
  exit 2
 } ; fi
 # unable to force codes below into subshell, tried using for loop
 argSnipName="${1}" ; shift 1 # name of the snippet filetype
 if [ $# -eq 0 ] && test -n ${curFiletype+x} ; then {
  true
 } ; elif [ $# -gt 0 ] && [ "$1" != '--' ] ; then {
  argFileType="${1}" ; shift 1 # name of the intended filetype to find the snippet for
 } ; else {
  echo "$PROGNAME: arg for file type (major-mode) is null" >&2
  exit 1
 } ; fi

 if [ -z "${argFileType}" ] ; then {
  echo "$PROGNAME: arg for file type (major-mode) is null" >&2
  exit 1
 } ; elif [ -z "${argSnipName}" ] ; then {
  echo "$PROGNAME: arg for snippet name is null" >&2
  exit 1
 } ; fi

 ## constructing the full path to the snippet file:

 # temporary holder for filetype (the arg filetype or the parent filetype of the arg filetype, e.g. makefile filetype has its parent as sh):
 lastFiletype='' # used for breaking loop
 curFiletype="${argFileType}"
 curParentFilename='' # the temporary holder for the .parent filename:
 curSnipFileName='' 
 gbParentsArray[0]="${argFileType}" # array of parent filetypes come across while searching parent tree for the snippet file
 gbParentsArraySize=''
 # curSnipArgFileName=''
 loopCount=0
  # includerFileArray='' # string to hold snippet include files (include files are files that set variables prior to loading the real snip file, e.g. sh/header.arg set COMMENT variable approriately prior to loading _base/header).
 transformCmd='' # a command string used to transform text from parent snippet into child snippet (e.g. transforming single $ in sh into $$ in makefile)
 curTransformCmd='' # a holder for current transformCmd 
 
 while [ $loopCount -lt $DEFAULT_MAX_LOOPCOUNT ] && [ "${curFiletype}" != "${lastFiletype}" ] ; do {
  loopCount=$(($loopCount + 1))
  lastFiletype="${curFiletype}"
  
  curSnipFileName="${BASEDIR}/${curFiletype}/${argSnipName}"
  # if gbParentsArray last element does not include $curFiletype, then include it:
  if [ "${gbParentsArray[$((${#gbParentsArray[@]}-1))]}" != "${curFiletype}" ] ; then {
   gbParentsArray[${#gbParentsArray[@]}]="${curFiletype}"
  } ; fi
  
  if [ -f "${curSnipFileName}" ] ; then {
   break
  } ; fi
  
  # if exist a file called .parent:
  curParentFilename="${BASEDIR}/${curFiletype}/${PARENT_FILENAME}"
  if [ ! -f "${curParentFilename}" ] ; then {
   # if current dir is already BASE_FILETYPE dir, conclude the search for snippet file as failure:
   if [ "${curFiletype}" = "${BASE_FILETYPE}" ] ; then {
    echo "$PROGNAME: snippet file not found: ${curSnipFileName}" >&2
    exit 1
   } ; else {
     # last search: searching the $BASEDIR/$BASE_FILETYPE folder for the snippet:
    curFiletype="${BASE_FILETYPE}"  
    continue
   } ; fi
  } ; else { # if exist .parent file:
   # searching for snippet file in parent's dir. Parent's dir is read from the ${PARENT_FILENAME} in the current dir:
   # note: for simplicity only get the 1st dir mentioned in the .parent file:
   parentFileContent="$(grep -Ev '^[ \t]*#' "${curParentFilename}" | sed '/^$/d')" ; imm_retval=$?
   if [ $imm_retval -ne 0 ] ; then {
    echo "ERROR: failed reading parent file: ${parent_filename}" >&2
    exit 1
   } ; fi
   # if .parent file has no content or failed to read its content:
   if [ -z "$parentFileContent" ] ; then {
    echo "$(basename $0):ERROR: parent file's content is empty: ${parent_filename}" >&2 
    exit 1
   } ; else {
    curFiletype="$(echo "${parentFileContent}" | head -1)"
    if [ $(echo "${parentFileContent}" | wc -l) -ge 2 ]; then {
     transformCmd="${transformCmd} | $(echo "${parentFileContent}" | tail -1)"
    } ; fi
   } ; fi
   continue
  } ; fi
 } ; done
 
 if [ $loopCount -gt $DEFAULT_MAX_LOOPCOUNT ] ; then {
  # this means maximum number of looping into parent dirs has reached:
  echo "$ERR maximum recursing of parent modes reached without finding snippet file ${curSnipFileName}" >&2
  exit 1
 } ; fi

 if [ ! -f "${curSnipFileName}" ] ; then {
  echo "$ERR: snippet file not found: ${curSnipFileName}" >&2
  exit 1
 } ; else {
  # counter=1
  # while [ $counter -lt ${#includerFileArray[@]} ] ; do {
  #  . "${includerFileArray[$counter]}"
  #  counter=$(($counter+1))
  # } ; done
  eval ". ${curSnipFileName} ${@} ${transformCmd}"
 } ; fi
} # expandSnip

# ========================= MAIN =========================
## parsing argument:
if [ $# -eq 0 ] ; then echo "$Usage" ; exit ; fi

expandSnip "$@"
