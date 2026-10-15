#!/bin/bash
name=mariadb

docker container create \
	--name "$name" \
	--net mynet \
	--init \
	image-$name
docker container cp context/myinit.sh "$name":/usr/bin
docker container start "$name"
