#!/usr/bin/bash

ssh -o StrictHostKeyChecking=no ubuntu@$(cat instance_ip) 'uname -a'
exit 0
sshsudo systemctl stop apache2
cat /var/www/html/.env >> /etc/apache2/envvars

