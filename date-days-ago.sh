#!/usr/bin/env bash

usage() {
	echo "Script take how many days ago as a parameter: \
$0 <days>"
}

if [[ -z $1 ]]; then
  usage && exit 1
fi
DAYSAGO=$1

OSNAME=$(uname -s)

if [[ ${OSNAME} == "Linux" ]]; then
    IFS='%' DATESTRING="-d ${DAYSAGO} days ago"
    elif [[ ${OSNAME} == "Darwin" ]]; then
      DATESTRING="-v -${DAYSAGO}d"
    else
      echo "${OSNAME} not supported" && exit 1
fi

date ${DATESTRING}

exit $?
