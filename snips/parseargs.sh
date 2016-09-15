# collect flags:
flags=''
operands=''

while [ $# -gt 0 ] ; do
 curarg="$1" ; shift 1
 case "${curarg}" in
  -*) flags="${flags} $curarg" ;;
  *) operands="${operands} \"${curarg}\""
 esac
done
eval set -- "$operands"
