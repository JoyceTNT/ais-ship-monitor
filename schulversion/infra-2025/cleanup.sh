#!/bin/bash
#alles alter als 7 Tagen wird geloscht
mariadb -n mohalchami_db -e "DELETE FROM pos WHERE zeit < NOW() - INTERVAL 7 DAY;"

