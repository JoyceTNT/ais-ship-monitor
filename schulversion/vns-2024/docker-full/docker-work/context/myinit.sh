#!/bin/bash
log=/docker.log
echo starte >> $log

trap onexit SIGTERM 

function onexit {
  #shutdown ...
  exit
}
# start services
service ssh start

while true; do
  echo "$(date +%FT%T) ping" >> $log
  read -t 1 </dev/fd/1 
done
