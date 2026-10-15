#!/usr/bin/env bash

email="$1" 
betreff="$2" 
inhalt="$3"

LOGFILE="/data/workuser/log/simulation.log" 
 
sleep 0.3

echo "$(date): $email | $betreff | $inhalt" >> "$LOGFILE"
