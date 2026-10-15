#!/usr/bin/env bash


email="$1"
queue_dir="/data/workuser/mailqueue"
log_dir="/data/workuser/log"

LOGFILE="/data/workuser/log/enqueue_auftrag.log"

node_id="node-${EPOCHREALTIME/[.,]}"


echo "Auftrag: Sende eine E-Mail an $email" > "$queue_dir/$node_id"
echo "" >> "$queue_dir/$node_id" 

HEAD_FILE="$queue_dir/head"
TAIL_FILE="$queue_dir/tail"

if [ ! -f "$HEAD_FILE" ] || [ ! -s "$HEAD_FILE" ]; then
    echo "$node_id" > "$HEAD_FILE"
    echo "$node_id" > "$TAIL_FILE"

    chmod 777 "$HEAD_FILE" "$TAIL_FILE"
else
	alt_tail=$(cat "$TAIL_FILE")
        erste_zeile=$(head -n1 "$queue_dir/$alt_tail")
        echo "$erste_zeile" > "$queue_dir/$alt_tail"
        echo "$node_id" >> "$queue_dir/$alt_tail"

        echo "$node_id" > "$TAIL_FILE"
              
fi

echo "Auftrag erstellt: $node_id" >> "$LOGFILE"

