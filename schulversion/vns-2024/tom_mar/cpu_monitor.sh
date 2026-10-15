#!/bin/bash

# Log-Datei erstellen/leeren
echo "ElapsedSeconds,CPUPerc" > cpu_allgemein.csv

# Startzeit erfassen
START_TIME=$(date +%s)

# Hintergrundprozess: CPU-Daten sammeln
(
  while true; do
    # Verstrichene Sekunden berechnen
    ELAPSED=$(($(date +%s) - START_TIME))

    # CPU-Auslastung mit mpstat messen (5 Sekunden Intervall)
    CPU_PERC=$(mpstat 1 1 | awk '/all/ {print 100 - $NF}')  # 1 Sample nach 5 Sekunden

    # In CSV schreiben
    echo "$ELAPSED,$CPU_PERC" >> cpu_allgemein.csv

    sleep 1  # Intervall an mpstat anpassen
  done
) &
LOOP_PID=$!


k6 run test.js

# Hintergrundprozess stoppen
kill $LOOP_PID
