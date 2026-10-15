#!/bin/bash

email_pass="email_list.txt"

password_anfang=123456

> "$email_pass"

for i in {1..1000}; do
    email="user${i}@example.com"
    password=$((password_anfang + i - 1))
    echo "$email:$password" >> "$email_pass"
       mariadb -Ne "INSERT INTO user (email, password) VALUES ('$email', '$password');"
done

echo "100 emails und passwort $email_pass" >> email_list.txt

