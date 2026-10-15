#!/bin/bash

echo "Content-Type: text/plain"
echo ""

mariadb --defaults-file=/var/www/html/private/mariadb-defaults.cnf -e "Select * from user;"
