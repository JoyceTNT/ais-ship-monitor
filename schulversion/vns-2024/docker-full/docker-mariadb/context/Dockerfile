FROM ubuntu
RUN apt-get -y update && apt-get -y upgrade

RUN apt-get -y install vim tree iproute2 curl w3m ncat less procps
RUN apt-get -y install sudo
RUN apt-get -y install mariadb-server

RUN sed -i 's_^bind-address.*_bind-address = 0.0.0.0_g' /etc/mysql/mariadb.conf.d/50-server.cnf

COPY myinit.sh /usr/bin/

CMD ["/usr/bin/myinit.sh"]

