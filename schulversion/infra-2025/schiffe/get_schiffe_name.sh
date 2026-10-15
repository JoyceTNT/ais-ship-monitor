#!/bin/bash

log="/tmp/shipdata_$(date +%F).log"

ssh hopper ncat rhodes 8082 | while IFS='|' read -r -a parameter; do
  zeit="${parameter[0]}"
  typ="${parameter[1]}"
  mmsi="${parameter[2]}"
  lng="${parameter[8]}"
  lat="${parameter[9]}"

  if [ "$typ" = "5" ]; then
    name="${parameter[5]}"
    echo "$zeit,$mmsi,$name" >> "$log"
    mariadb -n mohalchami_db -e \
      "INSERT INTO schiffe (zeit, mmsi, name) VALUES ('$zeit', '$mmsi', '$name');"
  else
    if [ -n "$lng" ] && [ -n "$lat" ] && [[ "$lat" == *.* ]] && [[ "$lng" == *.* ]]; then
      name="Undefiniert"
      echo "$zeit,$mmsi,$name" >> "$log"
      mariadb -n mohalchami_db -e \
        "INSERT INTO schiffe (zeit, mmsi, name) VALUES ('$zeit', '$mmsi', '$name');"
    fi
  fi
done

