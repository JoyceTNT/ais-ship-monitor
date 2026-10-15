#!/bin/bash
log=/docker.log
echo starte >> $log

trap onexit SIGTERM 

function onexit {
  #shutdown ...
  echo shutting down >> $log
  /opt/tomcat/bin/shutdown.sh
  exit
}
echo trap handler set >> $log 
# start services
/etc/init.d/mariadb start
sudo -u mysql mariadb -e "drop database if exists dbdemo;
drop user if exists dbuser@'localhost';
drop user if exists dbuser@'%';
create database dbdemo;
create user dbuser@'%' identified by 'DB_PASSWORT';
grant all privileges on dbdemo.* TO dbuser@'%';
flush privileges;
use dbdemo;
create table demo (id int primary key auto_increment, name text);"

while true; do
  echo "$(date +%FT%T) ping" >> $log
  read -t 10 </dev/fd/1
done
