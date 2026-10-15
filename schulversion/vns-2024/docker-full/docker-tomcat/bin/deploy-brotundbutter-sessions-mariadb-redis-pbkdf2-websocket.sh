war=context/brotundbutter-sessions-mariadb-redis-pbkdf2-websocket.war
curl --location --netrc-file local/netrc --fail --upload-file "$war" "http://localhost:8080/manager/text/deploy?path=/app&update=true"
