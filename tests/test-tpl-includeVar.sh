
for i in 'markdown' 'sh'; do {
 echo "testing separator snippet for mode: ${i}: "
 bash -c ". tpl.sh separator "${i}""
 echo
} ; done
