#!/bin/bash
name=work
echo running "$name"
docker container create \
	--name "$name" \
	--network mynet \
	--publish 8022:22 \
	--ip 172.27.0.100 \
	--init \
	image-$name
docker container cp context/myinit.sh $name:/usr/bin
docker container start $name
docker container cp ~/.ssh/id_ed25519.pub $name:/home/user/.ssh/authorized_keys
docker container exec $name chown user:user /home/user/.ssh/authorized_keys
docker container exec $name chmod go-r /home/user/.ssh/authorized_keys
docker cp context/050_sudo_general work:/etc/sudoers.d/
docker exec -ti work chown root:root /etc/sudoers.d/050_sudo_general
