#!/bin/bash
name=redis
echo running "$name"
docker container create \
	--name "$name" \
	--network mynet \
	--init \
	image-$name
docker container cp context/myinit.sh $name:/usr/bin
docker container cp context/redis.conf $name:/etc/redis/
docker container start $name
