#!/usr/bin/env bash


queue_dir="/data/workuser/mailqueue"
head_file="$queue_dir/head"
tail_file="$queue_dir/tail"


if [ ! -f "$head_file" ] || [ ! -s "$head_file" ]; then
    exit 1 
fi

thehead=$(cat "$head_file")
node_pfad="$queue_dir/$thehead"

if [ ! -f "$node_pfad" ]; then
    echo "" > "$head_file"
    echo "" > "$tail_file"
    exit 1
fi

erste_zeile=$(head -n1 "$node_pfad")
next_node=$(tail -n1 "$node_pfad")

if [ -n "$next_node" ]; then
	echo "$next_node" > "$head_file"
else
	rm "$head_file" "$tail_file"
fi

email="${erste_zeile#Auftrag: Sende eine E-Mail an}"
betreff="Infra-2025"
inhalt="Wir freuen uns, Sie auf unserer Webseite willkommen zu heißen."

bash /data/workuser/simulate_mail.sh "$email" "$betreff" "$inhalt"

rm "$node_pfad"
