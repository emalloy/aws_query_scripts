#!/usr/bin/env bash


usage() {
     echo "Script takes AWS IP Address as a parameter: \
$0 <ipaddr> [<region>] [<profile>]"
}

if [[ -z $1 ]]; then
	usage && exit 1
fi

export IPADDR=$1
REGION=$2
PROFILE=$3

    aws --region ${REGION:-us-east-1}\
	    --profile ${PROFILE:-default}
	    ec2 describe-instances  \
    | jq --arg privateipaddress "${IPADDR}"  -r '.Reservations[].Instances[] | select ( .PrivateIpAddress == $privateipaddress )'

exit $?
