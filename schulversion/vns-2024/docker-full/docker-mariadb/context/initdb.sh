#!/bin/bash
sudo -u mysql mariadb -e "drop database if exists dbdemo;
drop user if exists dbuser@'localhost';
drop user if exists dbuser@'%';
create database dbdemo;
create user dbuser@'%' identified by 'DB_PASSWORT';
grant all privileges on dbdemo.* TO dbuser@'%';
flush privileges;"
