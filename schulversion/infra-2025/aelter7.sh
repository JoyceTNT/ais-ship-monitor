#!/usr/bin/env bash

mariadb -n infra-2025-l_db -Ne "DELETE FROM positions WHERE zeit < NOW() - INTERVAL 7 DAY;"

mariadb -n infra-2025-l_db -Ne "Delete from schiffe where zeit < Now() - Interval 7 day;"
