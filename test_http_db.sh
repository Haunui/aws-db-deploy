#!/usr/bin/bash

INSTANCE_IP=$(cat instance_ip)

a_c=0

test_ip() {
	INSTANCE_IP=$1
	r=$(curl -s -Ik http://$INSTANCE_IP/db_status | grep "HTTP/1.1")
	
	a_c=$(($a_c+1))


	if [[ "$r" =~ "200 OK" ]]; then
		if [[ $(curl -s http://$INSTANCE_IP/db_status) == 0 ]]; then
			echo "Attempt n°$a_c : $r (DB OK)"
			return 0
		else
			echo "Attempt n°$a_c : $r (DB CONNECTION FAILED)"
			return 1
		fi
	else
		echo "Attempt n°$a_c : $r (HTTP FAILED)"
		return 2
	fi
}


for i in {1..6}; do
	echo "IP : $INSTANCE_IP"
	echo ""

	test_ip $INSTANCE_IP

	if [ $? -eq 0 ]; then
		exit 0
	elif [ $i -eq 6 ]; then
		if [ $? -eq 1 ]; then
			echo "Database connection failed"
		elif [ $? -eq 2 ]; then
			echo "Can't access to the webserver"
		fi

		exit 1
	fi

	sleep 10
done
