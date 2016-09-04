# Author: Nguyen Cong Hai Created:	2016-01-08		Last change: 2016 Feb 16
# Version: 0.0.2
# vi: ft=make:fdm=marker:foldmarker=<<<,>>>:ts=2:sw=2:lbr:fo-=c:fo-=r:fo-=o:fo+=j

# ================ VARIABLES ==================
BIN_DIR=$(HOME)/bin



# Disable make's built-in rules and built-in variables for performance and preventing hidden bugs:
MAKEFLAGS += -rR
CMDFLAG=--verbose
SHELL=/bin/bash
PATH="/usr/local/bin:/usr/bin/:/bin"

# Avoid funny character set dependencies:
unexport LC_ALL
LC_COLLATE=C
LC_NUMERIC=C
export LC_COLLATE LC_NUMERIC

# Avoid interference with shell env settings
unexport GREP_OPTIONS

# C compiler settings:
CC=gcc
CCMDFLAGS=-Wall

define mkhardlink =
			if ! [ "$(1)" -ef "$(2)" ] ; then \
			 gvfs-trash "$(2)" ; \
			 ln $(CMDFLAG)  "$(1)" "$(2)" ; \
			fi
endef

%.sh: FORCE
		file_rootname="$(notdir $(basename $@))" \
		&& targetFile="$(BIN_DIR)/$${file_rootname}" \
		&& $(call mkhardlink,$(@),$${targetFile})	\
		&& chmod u+x $(CMDFLAG) "$${targetFile}"

FORCE: ;
