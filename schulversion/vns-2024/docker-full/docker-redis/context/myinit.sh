#!/bin/bash
log=/docker.log
echo starte >> $log

trap onexit SIGTERM 

function onexit {
  #shutdown ...
  exit
}
# start services
chown redis: /etc/redis/redis.conf
sudo -u redis redis-server /etc/redis/redis.conf
# useage: REDISCLI_AUTH=REDIS_PASSWORT redis-cli -h redis

while true; do
  echo "$(date +%FT%T) ping" >> $log
  read -t 1 </dev/fd/1 
done
