#!/bin/bash
name=haproxy
port=8000
echo running "$name" "$port"
docker container create \
	--name "$name" \
	--network mynet \
	--init \
	-p $port:80 \
	image-haproxy
docker container cp context/myinit.sh $name:/usr/bin
docker container cp context/haproxy.cfg $name:/etc/haproxy/
docker container start $name
