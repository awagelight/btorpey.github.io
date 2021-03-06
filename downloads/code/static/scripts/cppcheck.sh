#!/bin/bash
#
# helper script for cppcheck that defines a number of common parameters
# (also generates and includes compiler pre-defined macros)
#
# Copyright 2016 by Bill Torpey. All Rights Reserved.
# This work is licensed under a Creative Commons Attribution-NonCommercial-NoDerivs 3.0 United States License.
# http://creativecommons.org/licenses/by-nc-nd/3.0/us/deed.en
#

# its a very good idea to include compiler builtin definitions
TEMPFILE=$(mktemp)
cpp -dM </dev/null 2>/dev/null >${TEMPFILE}

SCRIPT_DIR=$(cd $(dirname ${BASH_SOURCE}) && /bin/pwd)
# if CPPCHECK_OPTS is empty, try using .cppcheckrc from different locations
SCRIPT_DIR=$(cd $(dirname ${BASH_SOURCE}) && /bin/pwd)
if [[ -z "${CPPCHECK_OPTS}" ]]; then
   # current dir
   if [[ -e ./.cppcheckrc ]]; then
      export CPPCHECK_OPTS=$(<./.cppcheckrc)
   # SRC_ROOT
   elif [[ -z ${SRC_ROOT} && -e ${SRC_ROOT}/.cppcheckrc ]]; then
      export CPPCHECK_OPTS=$(<${SRC_ROOT}/.cppcheckrc)
   # home dir
   elif [[ -e ~/.cppcheckrc ]]; then
      export CPPCHECK_OPTS=$(<~/.cppcheckrc)
   # script dir
   elif [[ -e ${SCRIPT_DIR}/.cppcheckrc ]]; then
      export CPPCHECK_OPTS=$(<${SCRIPT_DIR}/.cppcheckrc)
   fi
fi

# uncomment the following line if you need to override LD_LIBRARY_PATH for cppcheck
# note that you must also supply the required path in place of "<>"
#LD_LIBRARY_PATH=<>:$LD_LIBRARY_PATH \
cppcheck --include=${TEMPFILE} \
${CPPCHECK_OPTS} $*

[[ -f ${TEMPFILE} ]] && rm -f ${TEMPFILE} 2>&1 >/dev/null
