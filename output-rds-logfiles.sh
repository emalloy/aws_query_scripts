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

getlognames() {
aws --region ${REGION:-us-east-1}\
        --profile ${PROFILE:-default} \
        rds describe-db-log-files \
        --db-instance-identifier ${IID} \
       | jq -r '.DescribeDBLogFiles[].LogFileName' \
       | tee /tmp/${IID}.txt
}

getlognames
export LOGNAMES=$(cat /tmp/${IID}.txt)


for y in ${LOGNAMES}; do
aws --region ${REGION:-us-east-1} \
	--profile ${PROFILE:-default} \
	rds download-db-log-file-portion \
       	--db-instance-identifier ${IID} \
       	--log-file-name $y \
	--starting-token 0 \
	--output text | tee -a ${IID}-rds.txt
done


exit $?
