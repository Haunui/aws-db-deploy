#!/usr/bin/bash

INSTANCE_IP=$(cat instance_ip)

r=$(curl -s -Ik http://$INSTANCE_IP | grep "HTTP/1.1")

echo "$r"

if [[ "$r" =~ "200 OK" ]]; then
	echo "curl test ok."
else
	echo "curl test failed."
	exit 1
fi
