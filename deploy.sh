#!/usr/bin/bash


IMAGE_ID="ami-09e513e9eacab10c1"
KEY_NAME="HSAINT-keypair"
SG_ID="sg-0b84d36f2701b4e1a"
SUBNET_ID="subnet-0bcc3e037257089ac"

aws ec2 run-instances --image-id "$IMAGE_ID" --instance-type t2.micro --key-name "$KEY_NAME" --security-group-ids $SG_ID --placement AvailabilityZone=$SUBNET_0_ZONE --subnet-id $SUBNET_ID --network-interfaces "AssociatePublicIpAddress=true,SubnetId=$SUBNET_ID,DeviceIndex=0" --count 1 --block-device-mappings 'DeviceName=/dev/xvda,Ebs={DeleteOnTermination=false,VolumeSize=8}' --tag-specifications "ResourceType=instance,Tags=[{Key=Name,Value='HSAINT-instance'}]"
