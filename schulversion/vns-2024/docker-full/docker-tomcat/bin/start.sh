#!/bin/bash
name=tomcat
port=8080
docker container create \
	--name "$name" \
	--net mynet \
	--publish "$port":8080 \
	--init \
	image-tomcat
docker container cp context/myinit.sh "$name":/usr/bin
docker container start "$name"
