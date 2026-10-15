#!/bin/bash
log=/docker.log
echo starte >> $log

trap onexit SIGTERM 

function onexit {
  #shutdown ...
  echo shutting down >> $log
  /opt/tomcat/bin/shutdown.sh
  exit
}
echo trap handler set >> $log 
# start services
# configure tomcat for deployment
sed -i 's:^.*allow=.*$:  allow="^.*$"/>:g' /opt/tomcat/webapps/manager/META-INF/context.xml
sed -i '/^<!--therolesbegin-->/,/^<!--therolesend-->/d' /opt/tomcat/conf/tomcat-users.xml
roles='<!--therolesbegin-->\n'
roles+='  <role rolename="manager-script"/>\n'
roles+='  <role rolename="manager-gui"/>\n'
roles+='  <role rolename="manager-jmx"/>\n'
roles+='  <user username="manager" password="MANAGER_PASSWORT" roles="manager-script,manager-gui,manager-jmx"/>\n'
roles+='<!--therolesend-->\n'
roles+='</tomcat-users>\n'
sed -i "s:^\s*</tomcat-users>:$roles:g" /opt/tomcat/conf/tomcat-users.xml

sudo -u tomcat /opt/tomcat/bin/startup.sh
echo tomcat started >> $log

while true; do
  echo "$(date +%FT%T) ping" >> $log
  read -t 10 </dev/fd/1
done
