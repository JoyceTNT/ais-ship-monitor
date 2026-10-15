#!/usr/bin/env bash

LOGFILE="$HOME/repos/infra-2025-l/infra2025-project/logs/ncat_start.log"
WATCHLOG="$HOME/repos/infra-2025-l/infra2025-project/logs/watcher.log"
RESTARTLOG="$HOME/repos/infra-2025-l/infra2025-project/logs/ncat_restart.log"
KILLLOG="$HOME/repos/infra-2025-l/infra2025-project/logs/ncat_kill.log"

PID=""

ps -eo pid,ppid,cmd | grep "ssh hopper ncat --recv-only rhodes 8082" | grep -v grep > /tmp/ncat_pid.txt

while read -r pid ppid cmd; do
    PID="$pid"
done < /tmp/ncat_pid.txt

if [ -z "$PID" ]; then
    echo "$(date): Kein laufender ncat-Prozess gefunden." >> "$WATCHLOG"
else
    echo "$(date): Gefundener Prozess PID=$PID" >> "$WATCHLOG"
fi

last_sec=$(mariadb -N -e "SELECT UNIX_TIMESTAMP(MAX(received_time)) FROM schiffsdaten;" rhodes_db)

if [ -z "$last_sec" ] || [ "$last_sec" = "NULL" ]; then
    echo "$(date): Keine Daten in der Tabelle vorhanden." >> "$WATCHLOG"
    exit 1
fi

current_time=${EPOCHREALTIME/[.,]/}
last_microsec=$(( last_sec * 1000000 ))
diff_microsec=$(( current_time - last_microsec ))
diff_sec=$(( diff_microsec / 1000000 ))

if [ "$diff_sec" -gt 60 ]; then
    echo "$(date): Keine neuen Daten seit $diff_sec Sekunden." >> "$WATCHLOG"
    
    if [ -n "$PID" ]; then
        echo "$(date): Beende Prozess PID=$PID" >> "$WATCHLOG" 
        kill -9 "$PID"
	sleep 1
    fi >> $KILLLOG 2>&1

echo "$(date): Starte ncat neu." >> "$WATCHLOG"

bash /usr/lib/cgi-bin/nohup_ncat_restart.sh >> "$RESTARTLOG" 2>&1
else
    echo "$(date): Letzter Eintrag vor $diff_sec Sekunden. Alles ok!" >> "$WATCHLOG"
fi

