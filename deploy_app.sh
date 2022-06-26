#!/usr/bin/bash

source functions.sh

INSTANCE_IP=$(cat instance_ip)

SSH_OPTS="-o StrictHostKeyChecking=no"
SSH_LOGIN="$SSH_USER@$INSTANCE_IP"

while ! ssh $SSH_OPTS $SSH_LOGIN 'uname -a' &> /dev/null; do
	echo "Waiting for SSH to be UP .."
	sleep 5
done

echo "Stop apache2 .."
ssh $SSH_OPTS $SSH_LOGIN 'sudo systemctl stop apache2'

echo "Set MYSQL credentials"

ssh $SSH_OPTS $SSH_LOGIN "sudo cp /etc/apache2/envvars /tmp/envvars; sudo chown ubuntu /tmp/envvars"

cred=$(gen_cred)
ssh $SSH_OPTS $SSH_LOGIN "echo \"export MYSQL_USER=$(echo "$cred" | cut -d':' -f1)\" >> /tmp/envvars"
ssh $SSH_OPTS $SSH_LOGIN "echo \"export MYSQL_PASSWORD=$(echo "$cred" | cut -d':' -f2)\" >> /tmp/envvars"

ssh $SSH_OPTS $SSH_LOGIN "sudo mv /tmp/envvars /etc/apache2/envvars; sudo chown root /etc/apache2/envvars"

echo "Generate db.sql"
cat template_files/webapp/db.sql | sed "s/{{USER}}/$(echo "$cred" | cut -d':' -f1)/g" | sed "s/{{PASSWORD}}/$(echo "$cred" | cut -d':' -f2)/g" > webapp/db.sql

echo "Clear /var/www/html folder"
ssh $SSH_OPTS $SSH_LOGIN 'sudo rm -rf /var/www/html/*'

echo "Upload webapp files"
scp $SSH_OPTS -r webapp $SSH_LOGIN:~
ssh $SSH_OPTS $SSH_LOGIN 'sudo mv webapp/* /var/www/html/; sudo rm -rf webapp'

echo "Remove webapp generated files"
rm -f webapp/db.sql

echo "Import db.sql"
ssh $SSH_OPTS $SSH_LOGIN 'sudo mysql < /var/www/html/db.sql'

echo "Start apache2 .."
ssh $SSH_OPTS $SSH_LOGIN 'sudo systemctl start apache2'
