create database if not exists webapp;
grant all privileges on webapp.* to '{{USER}}'@'localhost' identified by '{{PASSWORD}}';
flush privileges;

create table french_words(id int auto_increment not null, word varchar(255) not null, primary key(id));
create table history(id int auto_increment not null,username varchar(255), score integer, game_date date not null, primary key (id));
