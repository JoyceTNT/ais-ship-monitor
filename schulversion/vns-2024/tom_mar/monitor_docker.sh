#!/bin/bash

# Log-Datei erstellen/leeren
echo "ElapsedSeconds,CPUPercMariaDB,CPUPercTomcat" > docker_usage.csv

# Startzeit erfassen
START_TIME=$(date +%s)

# Hintergrundprozess: CPU-Daten jede Sekunde sammeln
(
  while true; do
    # Verstrichene Sekunden berechnen
    ELAPSED_SECONDS=$(($(date +%s) - START_TIME))

    # Docker-Stats abfragen und in Variablen speichern
    CPU_STATS=$(docker stats --no-stream --format "{{.Name}},{{.CPUPerc}}" tomcat mariadb 2>/dev/null | awk -F',' '{print $1,$2}')

    # CPU-Werte extrahieren (MariaDB und Tomcat)
    MARIADB_CPU=$(echo "$CPU_STATS" | awk '/mariadb/ {gsub(/%/, "", $2); print $2}')
    TOMCAT_CPU=$(echo "$CPU_STATS" | awk '/tomcat/ {gsub(/%/, "", $2); print $2}')

    # Werte in CSV schreiben (eine Zeile pro Sekunde)
    echo "$ELAPSED_SECONDS,$MARIADB_CPU,$TOMCAT_CPU" >> docker_usage.csv

    sleep 1
  done
) &
LOOP_PID=$!

# k6-Test ausführen
k6 run test.js

# Hintergrundprozess stoppen
kill $LOOP_PID
