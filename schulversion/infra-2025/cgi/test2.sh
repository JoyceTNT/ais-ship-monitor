#!/bin/bash

cookie=$(pwgen 40 1)
session_dir="/tmp/mysession-$cookie"
mkdir -p "$session_dir"

email=$(echo "$QUERY_STRING" | cut -d ";" -f1 | cut -d "=" -f2 | sed "s/[^a-zA-Z0-9@.\-]//g")
password=$(echo "$QUERY_STRING" | cut -d ";" -f2 | cut -d "=" -f2 | sed "s/[^a-zA-Z0-9]//g")

# Use a safer query (example with password hashing requires server-side logic)
check=$(mariadb -n infra-2025-l_db --defaults-file=/var/www/html/private/mariadb-defaults.cnf -e "SELECT * FROM user WHERE email = '$email'")

if test -n "$check"; then
    echo "$email" > "$session_dir/email.txt"
    echo "Content-Type: text/html"
    echo "Set-Cookie: __SECURE-mysession=$cookie; Secure; HttpOnly; SameSite=Strict; Path=/"
    echo ""
    echo "Anmeldung erfolgreich. Cookie ist $cookie"
    datum=$(date +'%d-%m-%Y %H:%M:%S')
    echo "$datum|$email|Willkommen auf der Webseite|Herzlich willkommen! $email" | nc localhost 8000
else
    echo "Content-Type: text/html"
    echo ""
    echo "Fehler bei der Anmeldung."
fi
