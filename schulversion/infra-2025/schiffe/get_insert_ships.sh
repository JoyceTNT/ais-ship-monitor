#!/bin/bash

log="/tmp/shipdata_$(date +%F).log" 
# zum rhodes dann, zeit,mmsi,lng und lat echo
ncat rhodes 8082 | while IFS='|' read -r -a parameter; do
  zeit="${parameter[0]}"   
  mmsi="${parameter[2]}"
  lon="${parameter[8]}"
  lat="${parameter[9]}"
  echo "$zeit,$mmsi,$lon,$lat"
#In mariadb einspeichern
mariadb -n infra-2025-l_db -e "Insert into positions (zeit,mmsi,lon,lat) values ('$zeit','$mmsi','$lon','$lat');"

done


