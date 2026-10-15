#!/bin/bash
name="work"
if test "$1" != ""; then
	name="$1"
fi

docker rm -f "$name"
