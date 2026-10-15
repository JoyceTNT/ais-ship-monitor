#!/bin/bash

# Log-Datei erstellen/leeren
echo "ElapsedSeconds,CPUPercTomcat,CPUPercTomcat2,CPUPercHAProxy" > docker_usage.csv

# Startzeit erfassen
START_TIME=$(date +%s)

# Hintergrundprozess: CPU-Daten jede Sekunde sammeln
(
  while true; do
    # Verstrichene Sekunden berechnen
    ELAPSED_SECONDS=$(($(date +%s) - START_TIME))

    # Docker-Stats abfragen und verarbeiten
    CPU_STATS=$(docker stats --no-stream --format "{{.Name}},{{.CPUPerc}}" tomcat tomcat2 haproxy 2>/dev/null | awk -F',' '{print $1,$2}')

    # CPU-Werte extrahieren
    TOMCAT_CPU=$(echo "$CPU_STATS"    | awk '/tomcat/ && !/tomcat2/ {gsub(/%/, "", $2); print $2}')  # Nur "tomcat"
    TOMCAT2_CPU=$(echo "$CPU_STATS"   | awk '/tomcat2/ {gsub(/%/, "", $2); print $2}')
    HAPROXY_CPU=$(echo "$CPU_STATS"   | awk '/haproxy/ {gsub(/%/, "", $2); print $2}')

    # Werte in CSV schreiben
    echo "$ELAPSED_SECONDS,$TOMCAT_CPU,$TOMCAT2_CPU,$HAPROXY_CPU" >> docker_usage.csv

    sleep 1
  done
) &
LOOP_PID=$!

# k6-Test ausführen
k6 run test.js

# Hintergrundprozess stoppen
kill $LOOP_PID
