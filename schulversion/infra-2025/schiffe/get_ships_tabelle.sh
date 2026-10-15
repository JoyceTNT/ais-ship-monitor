#!/bin/bash
echo "Content-Type: text/plain"
echo ""
#speichert die letzte nachricht eines schiffes, damit es in der 3 tabelle gezeigt wurde
mariadb --defaults-file=/var/www/html/private/mariadb-defaults.cnf -Ne \
"SELECT p.zeit, p.mmsi, p.lng, p.lat
 FROM pos p
 INNER JOIN (
   SELECT mmsi, MAX(zeit) AS max_zeit
   FROM pos
   GROUP BY mmsi
 ) AS latest
 ON p.mmsi = latest.mmsi AND p.zeit = latest.max_zeit
 ORDER BY p.zeit DESC;" | while IFS=$'\t' read -r zeit mmsi lng lat; do
  echo "$zeit,$mmsi,$lng,$lat"
done
