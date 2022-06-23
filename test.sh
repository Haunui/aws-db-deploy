#!/usr/bin/bash

INSTANCE_IP=$(cat instance_ip)

r=$(curl -s -Ik http://$INSTANCE_IP | grep "HTTP/1.1")

echo "IP : $INSTANCE_IP"
echo "RESPONSE : $r"

if [[ "$r" =~ "200 OK" ]]; then
	echo "TEST OK"
else
	echo "TEST FAILED"
	exit 1
fi
