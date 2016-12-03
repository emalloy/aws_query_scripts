#!/usr/bin/env bash


usage() {
     echo "Script takes aws region and profile as parameters: \
$0 [<region>] [<profile>]"
}

if [[ -z $1 ]]; then
	usage && exit 1
fi

REGION=$1
PROFILE=$2

    aws --region ${REGION:-us-east-1}\
	    --profile ${PROFILE:-default} \
	    ec2 describe-addresses \
    | jq -r '.Addresses[] | select ( .AssociationId  == null )| .PublicIp, .AllocationId'

exit $?
