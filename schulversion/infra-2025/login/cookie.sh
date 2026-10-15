#!/bin/bash

echo "Content-type: text/plain"
echo ""

token=$(pwgen 40 1)
session_dir="/tmp/mysession-$token"
mkdir -p "$session_dir"
echo "test@example.com" > "$session_dir/user"

echo "Set-Cookie: mysession=$token"
echo ""
echo "Session created: $session_dir"

