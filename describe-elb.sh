#!/usr/bin/env bash

usage() {
	echo "Script takes AWS ELB DnsName as a parameter: \
$0 <dnsname> [<region>] [<profile>]"
}

if [[ -z $1 ]]; then
  usage && exit 1
fi
DNSNAME=$1
REGION=$2
PROFILE=$3

aws --region ${REGION:-us-east-1} \
	--profile ${PROFILE:-default} \
	elb describe-load-balancers \
	| jq --arg dnsname "${DNSNAME}" -r '.LoadBalancerDescriptions[] | select ( .DNSName == $dnsname )' 

exit $?
