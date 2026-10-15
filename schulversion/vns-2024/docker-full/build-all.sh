#!/bin/bash
docker system prune -f -a
general/delete-all-containers.sh
general/prune-all.sh
general/create-mynet-network.sh
for i in mariadb redis tomcat haproxy work; do
	cd docker-$i
	bin/build.sh
	bin/start.sh
	cd ..
done
ssh-keygen  -R '[localhost]:8022'
ssh-keyscan -p 8022 localhost >> ~/.ssh/known_hosts
