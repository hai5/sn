# AUTHOR: Cong Hai Nguyen
# CREATED: Sat Aug 20 10:22:10 ICT 2016
# VERSION: 0.0.1

MAKEFLAGS += -rR
SHELL=/bin/bash
CMDFLAGS=--verbose


~/bin/sn: sn.sh
	cp -u $(CMDFLAGS) "$^" "$@" 

install: ~/bin/sn

uninstall: 
	rm $(CMDFLAGS) ~/bin/sn

FORCE: ;
