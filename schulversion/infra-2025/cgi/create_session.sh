#!/bin/bash

cookie=$(pwgen 40 1)


session_dir="/tmp/mysession-$cookie"
mkdir -p "$session_dir"


email=$(echo "$QUERY_STRING" | cut -d ";" -f1 | cut -d "=" -f2)
password=$(echo "$QUERY_STRING" | cut -d ";" -f2 | cut -d "=" -f2)


check=$(mariadb --defaults-file=/var/www/html/private/mariadb-defaults.cnf -e "select * from user where email = \"$email\" and password = \"$password\"")

if test -n "$check"; then

    echo "$email" > "$session_dir/email.txt"
    echo "$password" > "$session_dir/password.txt"

    echo "Content-Type: text/html"
    echo "Set-Cookie: __SECURE-mysession=$cookie; Secure; HttpOnly; SameSite=Strict; Path=/localhost:8080/"
    echo ""
    echo "Anmeldung erfolgreich. Cookie ist $cookie"
    datum=$(date +'%d-%m-%Y %H:%M:%S')
    echo "$datum|$email|Willkommen auf der Webseite|Herzlich willkommen! $email" 
else
    echo "Fehler bei der Anmeldung."
fi
