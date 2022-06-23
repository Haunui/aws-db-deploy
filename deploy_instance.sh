#!/usr/bin/bash


IMAGE_ID="ami-09e513e9eacab10c1"
KEY_NAME="HSAINT-keypair"
SG_ID="sg-0b84d36f2701b4e1a"
SUBNET_ID="subnet-0bcc3e037257089ac"

INSTANCE_ID=$(aws ec2 run-instances --image-id "$IMAGE_ID" --instance-type t2.micro --key-name "$KEY_NAME" --security-group-ids $SG_ID --placement AvailabilityZone=$SUBNET_0_ZONE --subnet-id $SUBNET_ID --network-interfaces "AssociatePublicIpAddress=true,SubnetId=$SUBNET_ID,DeviceIndex=0" --count 1 --block-device-mappings 'DeviceName=/dev/xvda,Ebs={DeleteOnTermination=false,VolumeSize=8}' --tag-specifications "ResourceType=instance,Tags=[{Key=Name,Value='HSAINT-instance'}]" --user-data "$(cat user_data)" --query 'Instances[0].InstanceId' | sed 's/"//g')

echo "Instance '$INSTANCE_ID' starting initialized"
sleep 2

while [[ $STATE != running ]]; do
	STATE=$(aws ec2 describe-instances --filters Name=tag:Name,Values=HSAINT-instance --instance-ids $INSTANCE_ID | jq ".Reservations[0].Instances[].State.Name" | sed 's/"//g')
	echo "Waiting for instance '$INSTANCE_ID' to start.. (status : $STATE)"
	sleep 10
done

echo "Retrieving instance IP.."
INSTANCE_IP=$(aws ec2 describe-instances --instance-ids $INSTANCE_ID --query "Reservations[0].Instances[0].PublicIpAddress" | sed 's/"//g')

echo "Writing INSTANCE_IP in instance_ip file.."
echo "$INSTANCE_IP" > instance_ip
