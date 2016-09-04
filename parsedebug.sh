#!/bin/sh
# author: Nguyen Cong Hai
# created: 2016-07-29

cat <<EOF
for args; do
    case "\$args" in
     --debug) set -x ; shift 1 ;;
     *) break ;;
     esac
done
EOF

# cat  << EOF
# # parsing argument:
# if [ \$# -eq 0 ] ; then echo "\$Usage" ; exit ; fi

# # first loop: break singleFlags-combo into single flags:
# for i in "\$@" ; do {
#  curArg="\${i}" 
#  case "\${curArg}" in
#   -*) # capturing singleFlags-combo:

#    # if curArg is indeed a singleFlags-combo:
#    if (echo "" | grep -Eq '^\-[0-9A-Za-z]{2,}\$') ; then {

#     # turn curArg into a series of single flags:
#     newcurArg=""

#     # reset args:
#     shift 1
#     eval set -- \${newcurArg} "\$@"
#     break
#    } ; fi
#    ;;
#     *) # all other cases: skip
#       continue
#       ;;
#    esac
# } ; done

# # now parsing with all single-flags combo broken down into individual single flags:
# ops=""
# nonFlagArgsCount=0
# nonFlagArgs=''
# isNoMoreFlag='f'

# while [ \$# -gt 0 ] ; do
#   curArg="\${1}" ; shift 1
#     case "\${curArg}" in
#     -h|--help)  prU ; exit \$? ;;
#     -v|--verbose|-n|--dry-run|--dryrun) # flag for this very script, not for the command inside it:
#      shift 1 && ((indx--))
#      scriptFlags="${scriptFlags} ${curArg}" # 'gl' means global (scope) of this variable
#      ;; 
#     --cmd-v|--cmd-verbose|--cmd-n|--cmd-dry-run|--cmd-dryrun)# print the command to run, for the inner command, not this wrapper code (if want to print both, use both flag):
#      shift 1 && ((indx--))
#      cmdFlags="${cmdFlags} ${curArg}"
#      ;;
#     --flagWithArg) 
#      if [ \$# -eq 0 ] ; then
#       echo "ERROR: expecting arguments for this flag: \${curArg}" >&2
#       exit 1
#      elif (echo "\${1}" | grep -Eq '^\-.*' ) ; then
#       echo "ERROR: flag ^\${curArg}\\\$: expecting non-flag args, but got \${1}" >&2
#       exit 1
#      fi
#     --) # marking the end of flags and beginning of non-flag args:
#        isNoMoreFlag='t'
#        ;;
#     *)
#       # if has '-' prefix: possibly a non-recognizable single flags:
#       if (echo "${curArg}" | grep -Eq '^\-') ; then {
#        if [ "\$isNoMoreFlag" = 'f' ] ; then {
#         echo "unrecognizable flag: ${curArg}" >&2 ; exit
#        } ; fi
#       } ; fi
#       nonFlagArgsCount=\$((\$nonFlagArgsCount+1))
#       nonFlagArgs="\${nonFlagArgs} '\${curArg}'"
#       ;;
#   esac
# done

# ## set args that does not belong to a flag back into the arg list:
# eval set -- \${nonFlagArgs}
# EOF
