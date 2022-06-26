#!/usr/bin/bash

source functions.sh

echo "Generate MYSQL_ROOT_PASSWORD"
MYSQL_ROOT_PASSWORD=$(gen_cred | cut -d':' -f2)
cat template_files/user_data | sed "s/{{ROOT_PASSWORD}}/$MYSQL_ROOT_PASSWORD/g" > user_data
echo "$MYSQL_ROOT_PASSWORD" > mysql_root_password

echo "Deploy instance"
INSTANCE_ID=$(aws ec2 run-instances --image-id "$AWS_DEPLOY_IMAGE_ID" --instance-type t2.micro --key-name "$AWS_DEPLOY_KEY_NAME" --security-group-ids $AWS_DEPLOY_SG_ID --placement AvailabilityZone=eu-west-3c --subnet-id $AWS_DEPLOY_SUBNET_ID --network-interfaces "AssociatePublicIpAddress=true,SubnetId=$AWS_DEPLOY_SUBNET_ID,DeviceIndex=0" --count 1 --block-device-mappings 'DeviceName=/dev/xvda,Ebs={DeleteOnTermination=false,VolumeSize=8}' --tag-specifications "ResourceType=instance,Tags=[{Key=Name,Value='HSAINT-instance'}]" --user-data "$(cat user_data)" --query 'Instances[0].InstanceId' | sed 's/"//g')

rm -f user_data

echo "Instance '$INSTANCE_ID' starting initialized"
sleep 2

while [[ $STATE != running ]]; do
	STATE=$(aws ec2 describe-instances --filters Name=tag:Name,Values=HSAINT-instance --instance-ids $INSTANCE_ID | jq ".Reservations[0].Instances[].State.Name" | sed 's/"//g')
	echo "Waiting for instance '$INSTANCE_ID' to start.. (status : $STATE)"
	sleep 10
done

echo "Retrieving instance IP.."
INSTANCE_IP=$(aws ec2 describe-instances --instance-ids $INSTANCE_ID --query "Reservations[0].Instances[0].PublicIpAddress" | sed 's/"//g')
echo "IP : $INSTANCE_IP"

echo "Writing INSTANCE_IP in instance_ip file.."
echo "$INSTANCE_IP" > instance_ip

echo "Send instance_ip file to bkp folder"
rsync -e "ssh -o StrictHostKeyChecking=no" -az "instance_ip" bkp@192.168.0.9:/volume1/aws-bkp/
