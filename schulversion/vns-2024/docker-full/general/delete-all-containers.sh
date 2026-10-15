#!/usr/bin/env bash
if test $(docker container ls -aq|wc -l) != 0; then
  docker container rm -f $(docker container ls -aq)
fi

