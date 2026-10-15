#!/bin/bash

# Mit crontab immer an sein soll.
# Speichert eine Nachricht in der letzten 5 Minuten eines Schiffes (mmsi).
# Und löscht MMSIs, die in den letzten 5 Minuten nichts gesendet haben.

data=""
start=${EPOCHREALTIME/[.,]/}  # Startzeit in Mikrosekunden

ssh hopper ncat rhodes 8082 | while IFS='|' read -r -a parameter; do
    zeit="${parameter[0]}"
    mmsi="${parameter[2]}"
    lng="${parameter[8]}"
    lat="${parameter[9]}"

    # Nur speichern, wenn lat und lng gültige Koordinaten sind (müssen . enthalten)
    if [[ "$lat" == *.* && "$lng" == *.* ]]; then
    # filtern zeilen mit der aktulle mmsi, um die neue mmsi auszudrucken
      data=$(echo "$data" | grep -v "^$mmsi,")
      data="$data"$'\n'"$mmsi,$zeit,$lng,$lat"
    fi

    current=${EPOCHREALTIME/[.,]/}
    diff=$(( (current - start) / 1000000 ))

    if (( diff >= 300)); then
      echo ""
      echo "$data" | while IFS=',' read -r mmsi zeit lng lat; do
        mariadb --defaults-file=/var/www/html/private/mariadb-defaults.cnf -Ne "
          INSERT INTO pos (mmsi, zeit, lng, lat)
          VALUES ('$mmsi', '$zeit', '$lng', '$lat');
        "
        echo "$mmsi,$zeit,$lng,$lat" >> /var/www/html/ships.csv
        echo " Gespeichert: $mmsi | $zeit | $lng , $lat"
      done

      inaktive_mmsi=$(mariadb --defaults-file=/var/www/html/private/mariadb-defaults.cnf -Ne "
        SELECT mmsi FROM pos
        GROUP BY mmsi
        HAVING MAX(zeit) < NOW() - INTERVAL 5 MINUTE;
      ")

      if [[ -n "$inaktive_mmsi" ]]; then
        echo "Inaktive MMSI (seit 5 Minuten):"
        echo "$inaktive_mmsi"

        mariadb --defaults-file=/var/www/html/private/mariadb-defaults.cnf -Ne "
          DELETE FROM pos
          WHERE mmsi IN (
            SELECT mmsi FROM (
              SELECT mmsi FROM pos
              GROUP BY mmsi
              HAVING MAX(zeit) < NOW() - INTERVAL 5 MINUTE
            ) AS inactive_mmsi
          );
        "
        echo "Gelöscht: Alle Daten dieser MMSIs."
      else
        echo "Alle MMSI sind aktiv."
      fi

      start=$current
      data=""
    fi
  done


