#!/bin/bash
#alles älter als 7 Tagen wird gelöscht

mariadb -n mohalchami_db -e "DELETE FROM pos WHERE zeit < NOW() - INTERVAL 7 DAY;"

