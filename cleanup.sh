#!/usr/bin/sh

INSTANCE_ID=$1

if [ -z "$INSTANCE_ID" ]; then
	echo "Usage: $0 <instance_id>"
	exit 1
fi

aws ec2 terminate-instances --instance-ids $INSTANCE_ID
