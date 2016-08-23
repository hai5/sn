make -C ..
CMD="${HOME}/bin/sn"
CMDFLAGS=''
# CMDFLAGS="-C $(pwd)"
describe "\033[1;36mcritical functionalities\033[0;0m"
  it "always produces non-null output"
      input="$("${CMD}" ${CMDFLAGS} if-i.sh)"
      assert present "$input"
      [ -z "$input" ] && exit 1
  end
  it "expand snippet in another folder"
      input="$("${CMD}" ${CMDFLAGS} ./sh/if-i.sh)"
      assert present "$input"
      [ -z "$input" ] && exit 1
  end
end
describe "\033[1;36mbasic snippet print\033[0;0m"
  it "plain non-base snippet"
      input="$("${CMD}" ${CMDFLAGS} if-i.sh)"
      expected="$(cat ./if-x.sh)"
      [ -z "$input" ] && exit 1
      assert equal "${input}" "${expected}"
  end
  it "plain non-base snippet in another folder"
      input="$("${CMD}" ${CMDFLAGS} ./sh/if-i.sh)"
      expected="$(cat ./sh/if-x.sh)"
      [ -z "$input" ] && exit 1
      assert equal "${input}" "${expected}"
  end
  it "non-base snippet with dollar sign"
      input="$("${CMD}" ${CMDFLAGS} begin.sh)"
      expected="$(cat ./begin-x.sh)"
      [ -z "$input" ] && exit 1
      assert equal "${input}" "${expected}"
  end
  it "non-base snippet with dollar sign in another folder"
      input="$("${CMD}" ${CMDFLAGS} ./sh/begin.sh)"
      expected="$(cat ./sh/begin-x.sh)"
      [ -z "$input" ] && exit 1
      assert equal "${input}" "${expected}"
  end
 end
describe "\033[1;36minheritance functionality\033[0;0m"
  it "makefile snippet inherited from sh snippet"
      input="$("${CMD}" ${CMDFLAGS} begin.makefile)"
      expected="$(sed -e 's/\$/\$\$/g' ./begin-x.sh)"
      [ -z "$input" ] && exit 1
      assert equal "$input" "$expected"
  end
  it "makefile snippet inherited from sh snippet in another folder"
      input="$("${CMD}" ${CMDFLAGS} ./sh/begin.makefile)"
      expected="$(sed -e 's/\$/\$\$/g' ./sh/begin-x.sh)"
      [ -z "$input" ] && exit 1
      assert equal "$input" "$expected"
  end
 end
describe "\033[1;36mnesting functionality\033[0;0m"
  it "nest snippet"
      input="$("${CMD}" ${CMDFLAGS} new.sh)"
      expected="$(cat ./new-x.sh)"
      assert equal "$input" "$expected"
  end
  it "nest snippet in another folder"
      input="$("${CMD}" ${CMDFLAGS} ./sh/new.sh)"
      expected="$(cat ./sh/new-x.sh)"
      assert equal "$input" "$expected"
  end
end
describe "\033[1;36mexpanding variable functionality\033[0;0m"
  it "expand var"
      input="$("${CMD}" ${CMDFLAGS} header.sh)"
      expected="$(cat ./header-x.sh)"
      assert equal "$input" "$expected"
  end
  it "expand var in another folder"
      input="$("${CMD}" ${CMDFLAGS} ./sh/header.sh)"
      expected="$(cat ./sh/header-x.sh)"
      assert equal "$input" "$expected"
  end
end
