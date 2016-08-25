# Name
 A shellscripts-based snippet/template program
 
 
 Version: 0.0.1 
 Author: Cong Hai Nguyen
 License: Please find the attached LICENSE file
 
# Description
Purpose: "Editor-independent, inheritable, and nestable snippets"

Features: 
1. Command-line based interface:<br/>
-> independnet of any editor<br/>
1. Snippet inheritance:<br/>
A snippet of one filetype inherits snippets of its parent's filetype. If it has the snippet of the same name then the child snippet overrides the parent one.
1. Text transformation of one snippet into another:<br/>
This program allow user just write one snippet and define a transformation command to adapt it on-the-fly into the snippet (usually from parent snippet into its child snippet) (for example from sh snippet into gnu makefile shell codes. Please see Usage for examples)
1. Snippet nesting:<br/>
In this system, snippets/templates are shellscripts -> they can call other snippets/templates. Hence snippet nesting.

# Usage:
## installing this program:

## test for this program (required ryldn's shpec):
shpec tst/sn_shpec.sh

## run program with debug on:
sn --debug if.sh
## print a simple snippet:
sn if.sh
## print a sh snippet inherited from parent (base) snippet:
sn header.sh
## print Gnu's makefile snippet transformed from sh snippet:
sn if.makefile
## nest snippet:
sn new.sh

## create a variable to use in snippet body:
file name for a snippet variable: v<snippetname>.<filetype> (or v<snippetname> if it is of the base filetype)
 
# Build:
## Dependencies:
   1. sh shell
   1. for testing this program: lehmannro's assert.sh https://github.com/lehmannro/assert.sh version 1.1 (LGPLv3 license)
# Downloading
# Files:
1. ~/.sn/<br/>
   base directory
1. ~/.sn/\_parent<br/>
file holding information about the parent filetype. 2 lines: line 1: the parent filetype, line 2: the transformation command
1. ~/.sn/sn.sh: the main executable for generating the required snippet/template. User can run any snippet file directly without running this executable, but it won't be able to do inheriting and tranforming the snippet of the parent's file type.
1. ~/.sn/\_base: directory holding base snippet scripts (the last dir to search for snippet if the snippet is not found in the higher-level directory)
1. ~/.sn/tests/:<br/>
script for testing
1. ~/.sn/sh/, ~/.sn/markdown/, ...: directory holding snippet scripts for printing out snippet string in specific mode such as sh-mode, markdown-mode, etc

# Design decision:
## Why not just let each snippet file expand on its own:
Then the snippet file has to exist before user could call it -> rewriting similar snippets for different file types



