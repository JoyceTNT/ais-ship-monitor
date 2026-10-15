FROM ubuntu
RUN apt-get -y update && apt-get -y upgrade

RUN apt-get -y install vim tree iproute2 curl w3m ncat less procps
RUN apt-get -y install haproxy
RUN apt-get -y install sudo wrk
COPY myinit.sh /usr/bin/

CMD ["/usr/bin/myinit.sh"]

