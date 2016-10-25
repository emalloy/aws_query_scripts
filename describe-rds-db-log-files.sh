#!/usr/bin/env bash


usage() {
     echo "Script takes AWS RDS DbInstanceIdentifier as a parameter: \
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
        rds describe-db-log-files \
        --db-instance-identifier ${IID} \
       | jq -r '.DescribeDBLogFiles[].LogFileName'


exit $?
