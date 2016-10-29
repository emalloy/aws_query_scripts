#!/usr/bin/env bash


usage() {
     echo "Script takes AWS ASG Name as a parameter: \
$0 <instance-id> [<region>]"
}

if [[ -z $1 ]]; then
	usage && exit 1
fi

export IID=$1
REGION=$2

aws --region ${REGION:-us-east-1}\
    autoscaling describe-auto-scaling-groups \
    --auto-scaling-group-name ${IID} \
    | jq  -r '.AutoScalingGroups[].Instances[].InstanceId' \
    | tee /tmp/iid.txt

export INSTANCEID=$(cat /tmp/iid.txt)

for y in $INSTANCEID; do
  aws --region ${REGION:-us-east-1} \
      ec2 describe-instances \
      | jq --arg instanceid "${INSTANCEID}" \
      -r '.Reservations[].Instances[] 
      | select ( .InstanceId == $instanceid )
      | .PublicIpAddress'
done
  

exit $?
