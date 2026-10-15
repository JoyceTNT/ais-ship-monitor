#!/usr/bin/env bash

LOGFILE="$HOME/repos/infra-2025-l/infra2025-project/logs/ncat_start.log"

cd /usr/lib/cgi-bin

nohup ./ncat_start.sh >>$LOGFILE 2>&1 &

