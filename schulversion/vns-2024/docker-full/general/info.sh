#!/usr/bin/env bash
docker network inspect mynet|jq '.[0]|[.Name,.IPAM.Config[0]["Subnet"]]'
echo
docker system df
echo
docker image ls --all
echo
docker container ls --format 'table {{.Image}}\t{{.Names}}\t{{.Size}}\t{{.Status}}'
