#!/usr/bin/env bash
# Empfängt AIS-Daten vom Hochschulserver (rhodes, Port 8082, erreichbar über hopper)
# und speichert jede Nachricht in daten/ais-daten.txt.
# Die Datei enthält höchstens MAX_ZEILEN Zeilen: ältere Daten werden automatisch gelöscht.

# Projektordner bestimmen (ein Ordner über diesem Skript)
PROJEKT_ORDNER="$(cd "$(dirname "$0")/.." && pwd)"
DATEI="$PROJEKT_ORDNER/daten/ais-daten.txt"
mkdir -p "$(dirname "$DATEI")"

MAX_ZEILEN=50000        # ungefähr die letzten 24 Stunden
KUERZEN_ALLE=1000       # nach so vielen neuen Zeilen wird die Datei gekürzt
TIMEOUT_SEKUNDEN=300    # so lange ohne Nachricht → Verbindung neu aufbauen

# Behält nur die neuesten MAX_ZEILEN Zeilen
datei_kuerzen() {
  tail -n "$MAX_ZEILEN" "$DATEI" > "$DATEI.tmp" && mv "$DATEI.tmp" "$DATEI"
}

zaehler=0

while true; do
  echo "$(date '+%F %T') Verbinde mit rhodes:8082 über hopper ..."

  while IFS= read -r -t "$TIMEOUT_SEKUNDEN" zeile; do
    echo "$zeile" >> "$DATEI"
    zaehler=$((zaehler + 1))
    if [ "$zaehler" -ge "$KUERZEN_ALLE" ]; then
      datei_kuerzen
      zaehler=0
    fi
  done < <(exec ssh -o BatchMode=yes -o ServerAliveInterval=30 hopper "ncat --recv-only rhodes 8082")

  # Hier landet man bei Verbindungsabbruch oder wenn zu lange nichts kam
  kill "$!" 2>/dev/null
  echo "$(date '+%F %T') Verbindung beendet, neuer Versuch in 10 Sekunden"
  sleep 10
done
