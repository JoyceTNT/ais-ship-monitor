#!/bin/bash
name="redis"
if test "$1" != ""; then
	name="$1"
fi

docker rm -f "$name"
