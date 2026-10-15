#!/bin/bash

echo "Content-type: text/plain"
echo ""

# Output die neuste position eines schiffes (letzte nachricht).
mariadb --defaults-file=/var/www/html/private/mariadb-defaults.cnf -Ne "
  SELECT p.zeit, p.mmsi, p.lng, p.lat
  FROM pos p
  INNER JOIN (
    SELECT mmsi, MAX(zeit) AS max_zeit
    FROM pos
    GROUP BY mmsi
  ) AS latest
  ON p.mmsi = latest.mmsi AND p.zeit = latest.max_zeit;
"

