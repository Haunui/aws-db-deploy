#!/usr/bin/bash

INSTANCE_IP=$(cat instance_ip)

a_c=0

test_ip() {
	INSTANCE_IP=$1
	r=$(curl -s -Ik http://$INSTANCE_IP | grep "HTTP/1.1")
	
	a_c=$(($a_c+1))


	if [[ "$r" =~ "200 OK" ]]; then
		echo "Attempt n°$a_c : $r (OK)"
		return 0
	else
		echo "Attempt n°$a_c : $r (FAILED)"
		return 1
	fi
}


for i in {1..100}; do
	echo "IP : $INSTANCE_IP"
	echo ""

	test_ip $INSTANCE_IP

	if [ $? -eq 0 ]; then
		exit 0
	elif [ $i -eq 100 ]; then
		echo "Can't access to the webserver ($INSTANCE_IP)"
		exit 1
	fi

	sleep 10
done
