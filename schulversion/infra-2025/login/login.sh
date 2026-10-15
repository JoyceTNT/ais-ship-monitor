#!/bin/bash

echo "Content-type: text/plain"
echo ""

EMAIL="${QUERY_STRING#*email=}"
EMAIL="${EMAIL%%&*}"

PASSWORD="${QUERY_STRING#*password=}"

account=$(mariadb --defaults-file=/var/www/html/private/mariadb-defaults.cnf -Ne \
"SELECT COUNT(*) FROM infra-2025-l_db.user WHERE email='$EMAIL' AND password='$PASSWORD';")

if [ "$account" == 1 ]; then
	token=$(pwgen 40 1)
	mkdir -p "/tmp/mysession-$token"
	echo "Content-type: text/plain"
	echo "Set-Cookie: mysession=$token"
	echo 
  echo " Login Erfolgreich"
  bash /data/workuser/enqueue_auftrag.sh "$EMAIL"
else
    echo " Falsche email oder password"
fi


