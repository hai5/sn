 #!/bin/bash
 # created: Fri Aug 12 08:33:48 ICT 2016
cmd="grep -Eq '^\-[_0-9A-Za-z]{2,}$'" 
echo -e "testing detecting long single combo flag:\n^${cmd}\$"
echo -e "\n true cases"

for i in "-abc" "-_abc" ; do
 printf "^${i}\$: "
 eval "echo "${i}" | ${cmd} || exit 1"
 echo "passed"
done

echo -e "\n false cases"
for i in "--abc" "-12a-" ; do
 printf -- "^${i}:\$"
 eval "echo "${i}" | ${cmd} && exit 1"
 echo "passed"
done
