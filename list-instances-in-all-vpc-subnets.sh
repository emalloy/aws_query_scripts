#!/usr/bin/env bash


usage() {
     echo "Script takes AWS VPC ID as a parameter: \
$0 <dnsname> [<region>] [<profile>]"
}

if [[ -z $1 ]]; then
  usage && exit 1
fi

export VPCID=$1
REGION=$2
PROFILE=$3
aws --region ${REGION:-us-east-1} \
	--profile ${PROFILE:-default} \
	ec2 describe-subnets \
 | jq --arg vpcid "${VPCID}" -r '.Subnets[] | select ( .VpcId == $vpcid ) | .SubnetId' \
 > /tmp/file
 
 
for y in `cat /tmp/file`; do
    aws ec2 describe-instances  \
	    --region ${REGION:-us-east-1} \
	    --profile ${PROFILE:-defaault} \
    | jq --arg vpcid "${VPCID}" --arg subnets "${y}" -r '.Reservations[].Instances[] | select ( .VpcId == $vpcid ) | select (.SubnetId == $subnets )'
done

exit $?
