#!/usr/bin/env bash
# author: Nguyen Cong Hai
# created: 2016-08-01
# version: 0.1.0
# description: please read README.md attached
#  change log:
#   v 0.0.8: changing from bash to sh for efficiency and portability -> change array into string (delimited with ' ')
# [ -n "$DEBUG" ]  && set -x

set -o errexit
set -o pipefail

PATH="/usr/local/bin:/usr/bin:/bin"
hash -r

# ========================= VARIABLES =========================

DEFAULT_SNIPDIR="${HOME}/sn" # as named

snipDir="${DEFAULT_SNIPDIR}" # the dir name to be used to find the snippet file

# STEP='var init' # for debugging: print out which step program is in (e.g main loop, variable initialization, etc) 

initFileType='' # filetype of the initial snippet being requested as arg. Used in expanding base- filetype variable to know which filetype it is expanding the variable to.

readonly VAR_PREFIX=".var" # file prefix for variable filetype (_v<VARNAME>.<filetype>)

readonly PARENT_PREFIX=".parent" # file prefix for parent metadata (e.g. Par.sh) (_p.<filetype>)

readonly DEFAULT_MAX_LOOPCOUNT=10 # prevent infinite loop

quitErr () {
 # perform some steps prior to quit with error:
 # echo "sn: $*. Filetypes so far: ${gbSnipArr}" >&2
 echo -e "$0: $*" >&2 
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

getNameSansExtension () {
 echo "$*" | sed -e 's/\.[^.]\+$//'
} # getNameSansExtension

_v () {
 # expand var
 # purpose: to setup variable for snippet:
 # each variable's value is stored in a seperate file
 # this function is called when a snippet has been found
 # args external: gbSnipArr # set by the expandSnip function. So some expandSnip function should be run first before running this function
 local thevarname varFileName varFileExt
 
 thevarname="${1}_${initFileType}"
 
 ## if variable already defined in environment, use it:
 eval "test -n \"\${${thevarname}+x}\"" \
     && echo "${thevarname}" \
     && return
 
 if [ -z "$initFileType" ] ; then
     varFileExt=''
 else
  varFileExt=".${initFileType}"
 fi
 # recursively call sn to expand the file _v<varname>.<filetype>:
 varFileName="$(dirname "${snipDir}")/v${1}${varFileExt}"
 eval "${thevarname}=\"\$($0 \"${varFileName}\" 2>&1 )\""
 eval "printf \"\${${thevarname}}\""
} # _v 

# ========================= MAIN =========================

expandSnip () {
 local snipName="${1}"
 local snipFileType='' # initial filetype, parsed from snipName
 local loopCount=0
 local parentFileType='' # type of parent file, as read from parent metafile
 local parentFileContent='' # parent's file content stripped off # and blank lines
 local transformCmd='' # a command string used to transform text from parent snippet into child snippet (e.g. transforming single $ in sh into $$ in makefile)
 local snipDir="${snipDir}"

 ## if no args given:
 [ $# -eq 0 ] && quitErr "expandSnip(): expecting args"

 ## FLAGS:
  case "$1" in
   --debug) set -x && shift 1 ;;  
   -C|--change-dir) snipDir="$2" ; shift 2 ;;
  esac

  ## change to dir:
 ## go to the current snippet dir:
  cd "${snipDir}"
 
  ## base case: if found snippet right away: execute it and quit:
  if [ -f "${snipName}" ] ; then #if0
      . "${snipDir}/${snipName}"
      return
  fi #if0: if not found snippet right away
  
 
 ## if reaching here, it means snipName is not found
 ## now traversing the filetype hierarchy:

 for loopCount in $(seq 1 $DEFAULT_MAX_LOOPCOUNT) ; do {
  
   ## now changing snippet extension to its parent filetype:
   ##   get filetype of current snippet:
 
   snipFileType="$(getExtension "${snipName}")" || quitErr "failed parsing filetype from ${snipName}" 1
   # if current snippet has no filetype/extension -> it is base filetype, which should have been caught  by the if clause just above this. so if it occurs here still, it means error:
   if [ -z "$snipFileType" ] ; then
       quitErr "snippet not found: dir=^${snipDir}\$ , snip=^${snipName}\$"
   fi
   
   ## replace current snippet's extension with its parent filetype:
   ### identify the file that hold information for parent filetype (and the transformation function):
    parentMetaFile="${PARENT_PREFIX}.${snipFileType}"
    
    ## get the non-extension part of the snippet's name:
    ## DONT MOVE: this is used not only inside the if statement below, but outside of it as well
    snipRootName="$(getNameSansExtension "${snipName}")"
    
    ## if there is no parent meta file -> it implies that the parent filetype is 'base'. If no such file, and this is not default snip dir: fall back to default snip dir. Otherwise, error:
    if [ ! -f "${parentMetaFile}" ] ; then #if2
        ## check if such a base snippet exist:
        if [ -f "${snipRootName}" ] ; then #if3
            snipName="${snipRootName}" # snippet found, update snippet name to be used for snippet expansion
            break
        else # otherwise fall back to DEFAULT_SNIPDIR
         if [ "$(readlink -e .)" != "$(readlink -e "${DEFAULT_SNIPDIR}")" ] ; then #4
             snipDir="${DEFAULT_SNIPDIR}"
             cd "${snipDir}"
             continue
         else #4
          quitErr "files not found: \
          snipDir=^$snipDir$ \
          snipname=^${snipName}\$ \
          parentmetafiles=^${parentMetaFile}\$ \
          "
         fi #4
        fi #3
    fi #if2

  ## parent metafile is found -> swap snip extension to that of its parent:
  ## cat-ting the parent file content, removing blank lines and lines starting with '##':
  parentFileContent="$(grep -Ev '^[ \t]*#' "${parentMetaFile}" | sed '/^$/d')" || quitErr "ERROR: failed removing blanks lines and ## lines: file=^${parentFilename}\$" 1
  # if .parent file has no content or failed to read its content:
  parentFileType="$(echo "${parentFileContent}" | head -1)"
  snipName="${snipRootName}.${parentFileType}"
  case "$(echo "${parentFileContent}" | wc -l)" in
   1) true ;;
   2) 
    curTransformCmd=" | $(echo "${parentFileContent}" | tail -1)" \
        || quitErr "ERROR: failed parsing 2nd line of variable parentFileContent: ${parentFileContent}"
        
    ## check for null var:
    for i in parentFileType parentFileContent curTransformCmd ; do
     eval "test -z \"\$$i\"" && quitErr "main loop ops: variable empty: $i" 1
    done
    transformCmd="${transformCmd} ${curTransformCmd}"
    ;;
   *) quitErr "parent file content malformed: expected 2 lines" ;;
  esac
  continue
 } ; done
  ## check loop conditions:
  if [ "$loopCount" -gt "$DEFAULT_MAX_LOOPCOUNT" ] ; then
      # this means maximum number of looping into parent dirs has reached:
      quitErr "maximum loop reached while finding snippet file ${snipName}" 1
  fi

 test -f "${snipName}" \
     || quitErr "BUG: snippet file not found but loop goes on until now.\
      final file: ${snipName}"
 
 ## go back to the initial snip dir in case the program search for other snippets nested inside the arg-ed snippet:
 eval ". \"${snipDir}/${snipName}\"${transformCmd}"
 
} # expandSnip

readonly SINGLE_INSTANCE_SN=1 || quitErr "only run 1 instance of sn for efficiency"
    
expandSnip "$@"
