# What?
 A shellscripts-based snippet/template program  that produces snippet strings in the shell's standard output stream (stdout).
# Why?
* The main program can handle inheritance, transformation, and nesting of snippets
    * Inheritance e.g. makefile snippets can inherit from sh snippets, so no need for re-writing
    * Transformation e.g. makefile snippets will transform all sh snippets they inherit from single $ symbol to $$ symbol (in makefile script, single $ symbol means the makefile variable, not the shell variable)
    * Nesting e.g. calling another snippet from inside a snippet, it is done by a shell command inside the body of the snippet.
* It is simple, portable, powerful (ala shell scripts). Snippet is written as a bash/python/etc shellscript.
* EACH "snippet" can run on their own since they are also shellscripts.
# Why not?
1. maybe not secure: executing shell-script -> anything goes. Duh.

# Usage:
1. print snippet/template to stdout:
   ```bash
   bash -c ". \<path-to-tpl.sh\>/tpl.sh \<snippet-name\> \<file-type\> [extra-arguments ...]"
   ```
   <br/>e.g. `bash -c ". /home/user/tpl.d/tpl.sh header sh"`
   <br/>this will produce a header snippet in sh syntax. if there is no sh/header.sh file, tpl will search for the parent folder (in this case it is _\_base_ folder) and source the file (in this case it is _\_base_/header.sh))
1. snippet nesting:
   <br/>put the function `expandSnip <some-snippet-name>` in the body of the snippet. Please see the file sh/new snippet for reference
1. snippet inheritance:
<br/>as in example above, if there is no header script in the sh folder,  tpl.sh will see if there is .parent file in the same folder -> it will read the .parent file and search for the folder whose basename is mentioned in .parent. if there is no .parent file, it will search for the default '_\_base_' folder
 ```bash
 printf "sh\nsed -e 's/\$/$$/g'" >> /home/user/tpl.d/sh/.parent 
 ```
 <br/>Inheritance in multiple level is fine - e.g. sml -> xml -> html
1. snippet transformation:
 e.g. as in the above example, when calling makefile snippet that inherits from sh snippet, it will automatically transform $ in sh snippets into $$ in makefile snippets
1. snippet pre-processing:
   <br/>this is to avoid repeating the same snippet with only slight variations, e.g. a file header is pretty much the same for each file type except the comment character (# for sh, ;; for elisp, etc). 
   <br/>to do so, create a file named _<filetype>/<snippetname>.arg_. e.g. sh/header.arg as seen in the sh folder

# Files:
Please find the attached MANIFEST file for more information (this list has not yet been fully updated though :( )


# Developers:
Originally developed by Cong Hai Nguyen.

# Copyright:
Please find the attached license file for copyright information

Version 0.0.1 2016-08-02 

