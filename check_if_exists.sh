#!/usr/bin/bash

exists=$(aws ec2 describe-instances --filters Name=tag:Name,Values=HSAINT-instance --query 'Reservations[0].Instances[0].InstanceId' | sed 's/"//g')

if [[ $exists != null ]]; then
	echo "$exists"
fi
