create database if not exists webapp;
grant all privileges on webapp.* to '{{USER}}'@'localhost' identified by '{{PASSWORD}}';
flush privileges;
