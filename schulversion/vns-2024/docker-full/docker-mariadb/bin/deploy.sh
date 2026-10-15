curl --location --netrc-file netrc --fail --upload-file "context/webapp.war" "http://localhost:8080/manager/text/deploy?path=/app&update=true"
