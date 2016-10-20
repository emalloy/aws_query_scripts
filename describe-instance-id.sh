#!/usr/bin/env bash


usage() {
     echo "Script takes AWS instance-id as a parameter: \
$0 <instance-id> [<region>] [<profile>]"
}

if [[ -z $1 ]]; then
	usage && exit 1
fi

export IID=$1
REGION=$2
PROFILE=$3

    aws --region ${REGION:-us-east-1}\
	    --profile ${PROFILE:-default} \
	    ec2 describe-instances  \
    | jq --arg instanceid "${IID}"  -r '.Reservations[].Instances[] | select ( .InstanceId == $instanceid )'

exit $?
