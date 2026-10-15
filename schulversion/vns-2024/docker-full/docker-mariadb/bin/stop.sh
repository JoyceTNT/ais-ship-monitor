#!/bin/bash
name="mariadb"
if test "$1" != ""; then
	name="$1"
fi
docker container rm -f "$name"
