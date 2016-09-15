  sed -e '0,/^[ \t]*$/ s#^[ \t]*0<<your_text>>#' <<filename>> # search from line 0 to first occurence of blank line , then replace the blank line with the word ONCE
