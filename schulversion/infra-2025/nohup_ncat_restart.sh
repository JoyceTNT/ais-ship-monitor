#!/usr/bin/env bash

LOGFILE=$HOME/repos/infra-2025-l/infra2025-project/logs/ncat_restart.log

echo "++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++" >> $LOGFILE

echo "Ncat-Restart ausgeführt: $(date) | User: $LOGNAME" >>$LOGFILE

bash /usr/lib/cgi-bin/nohup_ncat_start.sh >>$LOGFILE 2>&1

if test $? -eq 0; then
	echo "Ncat wurde erfolgreich neugestartet." >>$LOGFILE
else
	echo "FEHLER: Etwas ist schief gegangen." >>$LOGFILE
fi

