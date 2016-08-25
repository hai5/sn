#!/usr/bin/env bash
# author: Nguyen Cong Hai
# created: 2016-08-01
# version: 0.1.0
# description: please read README.md attached
#  change log:
#   v 0.0.8: changing from bash to sh for efficiency and portability -> change array into string (delimited with ' ')
# [ -n "$DEBUG" ]  && set -x

# ========================= VARIABLES =========================
DEFAULT_SNIPDIR="${HOME}/sn" # as named

gbInitSnipDir='' # the dir name to be used to find the snippet file. if snippet file name argument (in command line) has relative/absolute path -> the snippet's dir will be the initial snippet dir to operate on. if the snippet file not found in this dir, the program will try searching in the DEFAULT_SNIPDIR. note that when passing argument to set this initial dir, either -C or --change-dir flag or relative snippet name, not both the flag and the relative/absolute snippet file name

# STEP='var init' # for debugging: print out which step program is in (e.g main loop, variable initialization, etc) 

gbInitFtype='' # filetype of the initial snippet being requested as arg. Used in expanding base- filetype variable to know which filetype it is expanding the variable to.

# readonly VAR_PREFIX="_v" # file prefix for variable filetype (_v<VARNAME>.<filetype>)

readonly PARENT_PREFIX="_p" # file prefix for parent metadata (e.g. Par.sh) (_p.<filetype>)

readonly DEFAULT_MAX_LOOPCOUNT=10 # prevent infinite loop

# gbParentsArray="" # array of parent filetypes starting from the input filetype up to and including the found snippet's filetype. This is used to perform transformation operation from the found snippet to the snippet requested by caller

# gbSnipArr='' # array of parent filetypes come across while searching parent tree for the snippet file

# delimgbSnipArr=' '

# argSnipName='' # name of the snippet filetype


# ========== FUNCTION INIT ==========  
# STEP='func init'
 # gbSnipArrSize=${#gbSnipArr[@]} # for note on gbSnipArr, see args external note just above
  
# ## set variables if there is a <filetype>/<VARIABLE_NAME>.arg file
# for i in seq 0 ${#varNameArray[@]} ; do {
# curVarName="${varNameArray[$i]}" # current variable name to search for definition file 
# for i in ${@} ; do {
#  curVarName="${i}" # current variable name to search for definition file 
 
 # # not needed
 # ## traverse the parent tree to find a file named <variable-name>.arg:
 # for counter in $(seq 0 $(($gbSnipArrSize-1))) ; do {
 #  curFile="${gbInitSnipDir}/${gbSnipArr[$counter]}/${curVarName}.arg"   # current filename to process
 #  test -f "${curFile}" && eval "${curVarName}=\"$(cat "${curFile}")\"" && break
 # } ; done

# variables not set by the curFile loop above should be set by default values in _base (via the _base/<var-name>.arg file)
## set variable if not set by the curFile loop above:
 # curVarValue="${varValArray[$i]}"
 # eval "test -z \${${curVarName}+x} &&  ${curVarName}=\"${varValArray[$i]}\""
# } ;done
# for i in ${@} ; do eval "echo $i=\$${i}" ; done
# } # setVars

quitErr () {
 # perform some steps prior to quit with error:
 # echo "sn: $*. Filetypes so far: ${gbSnipArr}" >&2
 echo "sn: $*" >&2 
 shift 1
 if [ $# -gt 0 ] ; then
     exit "$1"
 else
  exit 1
 fi
} # quitErr

getExtension () {
 ## getting the args' filetype:
 if (echo "$*" | grep -Fq '.') ; then
     echo "$*" | sed -e 's/^.*\.\([^.]\+\)$/\1/g'
 else
  echo ""
  return 1
 fi
} # getExtension

getRootName () {
 echo "$*" | sed -e 's/\.[^.]\+$//'
} # getRootName

_v () {
 # purpose: to setup variable for snippet:
 # each variable's value is stored in a seperate file
 # this function is called when a snippet has been found
 # args external: gbSnipArr # set by the expandSnip function. So some expandSnip function should be run first before running this function
 local thevarname varFileName varFileExt
 
 thevarname="${1}_${gbInitFtype}"
 
 ## if variable already defined in environment, use it:
 eval "test -n \"\${${thevarname}+x}\"" \
     && echo "${thevarname}" \
     && return
 
 if [ -z "$gbInitFtype" ] ; then
     varFileExt=''
 else
  varFileExt=".${gbInitFtype}"
 fi
 # recursively call sn to expand the file _v<varname>.<filetype>:
 varFileName="$(dirname "${gbInitSnipDir}")/v${1}${varFileExt}"
 eval "${thevarname}=\"\$($0 \"${varFileName}\" 2>&1 )\""
 eval "printf \"\${${thevarname}}\""
} # _v 

# ========================= MAIN =========================

expandSnip () {
 ## temporary holder for filetype (the arg filetype or the parent filetype of the arg filetype, e.g. makefile filetype has its parent as sh):
 # lastFiletype='_' # used to guard against infinite loop, must not be empty all the time
 local curSnipFullName=''
 # local curSnipDir='' # current snip dir used to find snippet files. 
 # curParentFilename='' # name of file holding parent info about curSnipFullName
 # gbSnipArrSize=''
 # curSnipArgFileName=''
 local loopCount=0
 # includerFileArray='' # string to hold snippet include files (include files are files that set variables prior to loading the real snip file, e.g. sh/header.arg set COMMENT variable approriately prior to loading _base/header).
 local parentFileType='' # type of parent file, as read from parent metafile
 local parentFileContent='' # parent's file content stripped off # and blank lines
 local transformCmd='' # a command string used to transform text from parent snippet into child snippet (e.g. transforming single $ in sh into $$ in makefile)
 # # replaced by curSnipFullName
 # snipToSource='' # the ultimate physical snip file to be sourced, it will be identified via the loop
 # local filetype='' # the filetype of the arg snippet name

 ## if no args given:
 [ $# -eq 0 ] && quitErr "pls read README.md"

 ## FLAGS:
 # -C flag is better than passing relative path to snip name, i.e. `sn -C ~/sn/tst/if.sh` is better than `sn tst/if.sh` because the latter method always use caller's current dir by default whereas the former always use the default gbInitSnipDir by default:
 while [ $# -gt 0 ] ; do
  case "$1" in
   -d|--debug) set -x && shift 1 ;;  
   -*) quitErr "unrecognized flag ${1}" ;;
   # -C|--change-dir) readonly gbInitSnipDir="$(readlink -e "${2}")" && shift 2 || quitErr "failed parsing snip dir ${2}"  ;;
   *) break ;;
  esac || quitErr "failed parsing flags" 1
 done

 ## parsing argument:
 
 ## identifying the initial snippet dir:
 # if $1 has '/' in it -> user want to use snippet not in the default NSIPDIR (but parent snippet and all still be searched in gbInitSnipDir, unless user also wants to change gbInitSnipDir with -C flag):
 ## set the starting snip dir:
 if (echo "${1}" | grep -q '/') ; then
     curSnipFullName="$(readlink -f "${1}")"
 # curSnipDir="${gbInitSnipDir}"
 
     # quitErr 1 "no dir name in snip name please. use -C/--change-dir flag for that."
     # readonly gbInitSnipDir="$(dirname "${1}")"
     else
      curSnipFullName="${DEFAULT_SNIPDIR}/${1}"
      quitErr "gbInitSnipDir should not have been initiated already"
       # quitErr "either -C or --change-dir flag or relative snippet name, not both the flag and the relative/absolute snippet file name" 1
 # [ -z "$gbInitSnipDir" ] && readonly gbInitSnipDir="${DEFAULT_gbInitSnipDir}"
     fi

 ## set gbInitSnipDir:
 if [ -z "$gbInitSnipDir" ] ; then
     readonly gbInitSnipDir="$(dirname "${curSnipFullName}")" \
         || quitErr "gbInitSnipDir should not have been initiated already"
 else
  quitErr "gbInitSnipDir should not have been initiated already"
 fi
 
 ## set the the starting filetype:
 [ -z "$gbInitFtype" ] && readonly gbInitFtype="$(getExtension "${curSnipFullName}")"
 cd "${gbInitSnipDir}" 
 
 ## go to the current snippet dir:

 loopCount=0
 while true ; do {
  ## check loop conditions:
  if [ "$loopCount" -gt "$DEFAULT_MAX_LOOPCOUNT" ] ; then
      # this means maximum number of looping into parent dirs has reached:
      quitErr "maximum loop reached while finding snippet file ${curSnipFullName}" 1
  fi

  loopCount=$((loopCount+1))
  # lastFiletype="${curFtype}"

  ## base case: if found snippet right away: execute it and quit:
  if [ -f "${curSnipFullName}" ] ; then #if0
      break
  fi #if0: if not found snippet right away
  
   ## if reaching here, it means curSnipFullName is not found
   ## now changing snippet extension to its parent filetype:
   ##   get filetype of current snippet:
   curFtype="$(getExtension "${curSnipFullName}")" || quitErr "failed parsing filetype from ${curSnipFullName}" 1
   # if current snippet has no filetype (its name has no '.<filetype>' extension) -> assume it is base filetype, which should have been caught  by the if clause just above this:
   
   # if current file has no extension (i.e. its filetype is base, it should have been caught by the condition above
   if [ "${curFtype}" = "${curSnipFullName}" ] ; then # if1
       quitErr "snippet not found: ${curSnipFullName}" 1
   fi # if1
   
   ## replace current snippet's extension with its parent filetype:
    # innerloopcount=0
    # while [ $innerloopcount -lt 2 ] ; do #2
    # innerloopcount=$(($innerloopcount+1))
    ## identify the file that hold information for parent filetype (and the transformation function):
    parentMetaFile="$(dirname "${curSnipFullName}")/${PARENT_PREFIX}.${curFtype}"
    ## get the root part of the snippet's name:
    snipRootName="$(getRootName "${curSnipFullName}")"
    
    if [ ! -f "${parentMetaFile}" ] ; then #if2
        # if there is no parent meta file -> it means the parent filetype is 'base' -> check if such a base-filetype snippet exist (ie. snippet with same root name but no extension) and if so, use it:
        if [ -f "${snipRootName}" ] ; then #if3
            curSnipFullName="${snipRootName}" # snippet found, update snippet name to be used for snippet expansion
            break
        else # otherwise fall back to DEFAULT_SNIPDIR
         if [ "$(dirname "${curSnipFullName}")" != "${DEFAULT_SNIPDIR}" ] ; then #4
             curSnipFullName="${DEFAULT_SNIPDIR}/$(basename "${curSnipFullName}")"
             continue
         else #4
          quitErr "current snip dir: $(readlink -e .): files not found: ^${curSnipFullName}\$, ^${parentMetaFile}\$" 1
         fi #4
        fi #3
    fi #if2
   # done #2

  ## parent metafile is found -> swap curSnipFullName extension to that of its parent:
  parentFileContent="$(grep -Ev '^[ \t]*#' "${parentMetaFile}" | sed '/^$/d')" || quitErr "ERROR: failed parsing parent file: ${parentFilename}" 1
  # if .parent file has no content or failed to read its content:
  parentFileType="$(echo "${parentFileContent}" | head -1)"
  curSnipFullName="${snipRootName}.${parentFileType}"
  case "$(echo "${parentFileContent}" | wc -l)" in
   1) true ;;
   2) 
    curTransformCmd=" | $(echo "${parentFileContent}" | tail -1)" || quitErr "ERROR: failed parsing 2nd line of variable parentFileContent: ${parentFileContent}" 1
    # check for null var:
    for i in parentFileType parentFileContent curTransformCmd ; do
     eval "test -z \"\$$i\"" && quitErr "main loop ops: variable empty: $i" 1
    done
    transformCmd="${transformCmd} ${curTransformCmd}"
    ;;
   *) quitErr "parent file content malformed: expected 2 lines" ;;
  esac
  continue
 } ; done

 test -f "${curSnipFullName}" \
     || quitErr " snippet file not found. final file: ${curSnipFullName}" 1
 
 ## go back to the initial snip dir in case the program search for other snippets nested inside the arg-ed snippet:
 eval ". \"${curSnipFullName}\"${transformCmd}"
 
} # expandSnip

readonly SINGLE_INSTANCE_SN=1 || quitErr "only run 1 instance of sn for efficiency"
    
expandSnip "$@"
