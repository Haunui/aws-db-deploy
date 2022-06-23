#!/usr/bin/bash

INSTANCE_IP=$(cat instance_ip)

SSH_OPTS="-o StrictHostKeyChecking=no"
SSH_LOGIN="ubuntu@$INSTANCE_IP"

while ! ssh $SSH_OPTS $SSH_LOGIN 'uname -a' 2> /dev/null; do
	echo "Waiting for SSH to be UP .."
	sleep 5
done

STATE=$(sudo systemctl status apache2 | grep -iEo "Active: [a-z]+ \([a-z]+\)")
while ! [[ $STATE == Active: active (running) ]]; do
	echo "Waiting for Apache2 to be UP .."
	sleep 5
	STATE=$(sudo systemctl status apache2 | grep -iEo "Active: [a-z]+ \([a-z]+\)")
done
