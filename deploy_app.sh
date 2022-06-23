#!/usr/bin/bash

source functions.sh

INSTANCE_IP=$(cat instance_ip)

SSH_OPTS="-o StrictHostKeyChecking=no"
SSH_LOGIN="ubuntu@$INSTANCE_IP"

while ! ssh $SSH_OPTS $SSH_LOGIN 'uname -a' 2> /dev/null; do
	echo "Waiting for SSH to be UP .."
	sleep 5
done

echo "Stop apache2 .."
ssh $SSH_OPTS $SSH_LOGIN 'sudo systemctl stop apache2'

echo "Set MYSQL credentials"
cred=$(gen_cred)
ssh $SSH_OPTS $SSH_LOGIN "echo \"MYSQL_USER=$(echo "$cred" | cut -d':' -f1)\" >> /etc/apache2/envvars"
ssh $SSH_OPTS $SSH_LOGIN "echo \"MYSQL_PASSWORD=$(echo "$cred" | cut -d':' -f2)\" >> /etc/apache2/envvars"

echo "Generate db.sql"
cat webapp/templates/db.sql | sed "s/{{USER}}/$(echo "$cred" | cut -d':' -f1)/g" | sed "s/{{PASSWORD}}/$(echo "$cred" | cut -d':' -f2)/g" > webapp/files/db.sql

echo "Clear /var/www/html folder"
ssh $SSH_OPTS $SSH_LOGIN 'sudo rm -rf /var/www/html/*'

echo "Upload webapp files"
scp $SSH_OPTS -r webapp/* $SSH_LOGIN:/var/www/html/

echo "Remove webapp generated files"
rm -f webapp/files/db.sql

echo "Import db.sql"
ssh $SSH_OPTS $SSH_LOGIN 'sudo mysql < /var/www/html/db.sql'

echo "Start apache2 .."
ssh $SSH_OPTS $SSH_LOGIN 'sudo systemctl start apache2'
