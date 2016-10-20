#!/usr/bin/env bash

usage() {
	echo "Script expects aws tag value as first positional argument: \
$0 <tag_Value> [<region>] [<profile>]"		

if [[ -z $1 ]]; then
  usage && exit 1
fi

export _TAGSTRING=$1
REGION=$2
PROFILE=$3

aws  --region ${REGION:-us-east-1} \
	--profile ${PROFILE:-default} \
	ec2 describe-tags \
       	--filters Name=resource-type,Values=instance \
	| jq '.Tags[] | {Key,Value,ResourceId}' | jq '. | select(.Key=="Name")' | jq --arg tagstring "${_TAGSTRING}" '. | select(.Value | contains($tagstring))'

exit $?
