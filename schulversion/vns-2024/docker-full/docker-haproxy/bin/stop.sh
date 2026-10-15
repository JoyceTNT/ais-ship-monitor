name="haproxy"
if test "$1" != ""; then
	name="$1"
fi

docker rm -f "$name"
