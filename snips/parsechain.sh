## parse the flags into seperate operations (UNCHAINing the flag into individual lines):
printf "%q\n" "$*" | awk 'BEGIN { RS="[ \t]+[-]{1,2}"} {print}' | while IFS= read -r line ; do
## <<some-code-here>>
done
