#!/bin/bash

# Speichert das lat und lng eines Schiffes in Tabelle schiffe in MariaDB
data=""
start=${EPOCHREALTIME/[.,]/}  # Startzeit in Mikrosekunden

ssh hopper ncat rhodes 8082 | while IFS='|' read -r -a parameter; do
  zeit="${parameter[0]}"
  mmsi="${parameter[2]}"
  lng="${parameter[8]}"
  lat="${parameter[9]}"

  # Prüfen ob lat und lng gültige Koordinaten sind (müssen '.' enthalten)
  if [[ "$lat" == *.* && "$lng" == *.* ]]; then
    # Entferne vorherige Einträge für dieses MMSI
    data=$(echo "$data" | grep -v "^$mmsi,")
    data="$data"$'\n'"$mmsi,$lng,$lat"
  fi

  current=${EPOCHREALTIME/[.,]/}  # Aktuelle Zeit in Mikrosekunden
  diff=$(( (current - start) / 1000000 ))  # Differenz in Sekunden
    echo ""
    echo "Speichern in MariaDB (table: schiffe):"
    echo "mmsi,lng,lat" > /var/www/html/ships.csv

    echo "$data" | while IFS=',' read -r mmsi lng lat; do
      mariadb --defaults-file=/var/www/html/private/mariadb-defaults.cnf -Ne "
        INSERT INTO schiffe (mmsi, lng, lat)
        VALUES ('$mmsi', '$lng', '$lat');
      "
      echo "$mmsi,$lng,$lat" >> /var/www/html/ships.csv
      echo " Gespeichert als : $mmsi | $lng , $lat"
    done

    start=$current
    data=""
  fi
done

