#!/bin/bash
VERSION=0.55.2
if [ "$(uname -m)" = "aarch64" ]; then

	TAR=k6-v$VERSION-linux-arm64.tar.gz
	URL=https://github.com/grafana/k6/releases/download/v$VERSION/$TAR
	curl -s -OL $URL
	tar -xzf $TAR
	mv k6-v$VERSION-linux-arm64/k6 /usr/local/bin/k6
	rm -rf k6-v$VERSION-linux-arm64*
else ## k6 installation -- x86_64
	gpg -k
	gpg --no-default-keyring --keyring /usr/share/keyrings/k6-archive-keyring.gpg --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys C5AD17C747E3415A3642D57D77C6C491D6AC1D69
	echo "deb [signed-by=/usr/share/keyrings/k6-archive-keyring.gpg] https://dl.k6.io/deb stable main" | sudo tee /etc/apt/sources.list.d/k6.list
	apt-get update
	apt-get install k6
fi

