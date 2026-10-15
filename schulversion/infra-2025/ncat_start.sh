#!/usr/bin/env bash

LOGFILE="$HOME/repos/infra-2025-l/infra2025-project/logs/ncat_start.log"

echo "++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++" >>$LOGFILE

echo "Ncat-Start ausgeführt: $(date) | User: $LOGNAME" >> $LOGFILE

ssh hopper ncat --recv-only rhodes 8082 | while IFS='|' read -r -a parameter; do
    received_time="${parameter[0]}"
    mmsi="${parameter[2]}"
    lon="${parameter[8]}"
    lat="${parameter[9]}"
    if [[ "$lon" == *.* && "$lat" == *.* ]]; then
    echo "$mmsi,$lat,$lon,$received_time" >>$LOGFILE
    mariadb -n rhodes_db -e "INSERT INTO schiffsdaten (received_time, mmsi, lon, lat) VALUES ('$received_time', '$mmsi', '$lon', '$lat');"
else 
       echo "Ungültige Daten: $mmsi,$lat,$lon,$received_time" >>$LOGFILE
    fi       
done


