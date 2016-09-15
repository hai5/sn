#!/usr/bin/env bash

EMACS_MODE_DIR="${HOME}/.emacs-modes"
SN_MAIN_EL_FILE_BASENAME="sn.el"
# EMACS_AUTOLOAD_DIR="${HOME}/.emacs-autoloads"

linkInEmacsModeDir="${EMACS_MODE_DIR}/${SN_MAIN_EL_FILE_BASENAME}"
if [ -h "${linkInEmacsModeDir}" ] ; then
    if [ -n "$(find -L "${linkInEmacsModeDir}" -type l)" ] ; then
        echo "link broken: ${linkInEmacsModeDir}" >&2
        rm -v "${linkInEmacsModeDir}"
    else
     echo "link already existed and still working: ${linkInEmacsModeDir}" >&2
    fi
else    
 ln -vs "$(readlink -e "${SN_MAIN_EL_FILE_BASENAME}")" "${linkInEmacsModeDir}"
fi
# idx=0
# declare -a elFile

# for i in $(ls -Xd *.el) ; do {
#  elFile[idx]="${i}"
#  ((idx++))
# }; done
# ((idx--))

# if [ $idx -ge 0 ] ; then
#     ln -vs "$(readlink -e "${elFile[$idx]}")" "${EMACS_MODE_DIR}"
#     while [ $idx -gt 0 ] ; do {
#      ((idx--))
#      ln -vs "$(readlink -e "${elFile[$idx]}")" "${EMACS_AUTOLOAD_DIR}"
#     } ; done
# fi
