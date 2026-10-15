FROM ubuntu
RUN apt-get -y update && apt-get -y upgrade

RUN apt-get -y install vim tree iproute2 curl w3m ncat less procps
RUN apt-get -y install openjdk-21-jdk
RUN apt-get -y install sudo
COPY myinit.sh /usr/bin/
COPY tomcat-11.0.0.tar /opt/
RUN mkdir -p /opt/tomcat
RUN tar -xf /opt/tomcat-11.0.0.tar -C /opt/tomcat
RUN useradd tomcat
RUN chown -R tomcat:tomcat /opt/tomcat/
COPY mariadb-java-client-3.5.1.jar /opt/tomcat/lib/

CMD ["/usr/bin/myinit.sh"]

