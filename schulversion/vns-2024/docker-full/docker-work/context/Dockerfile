FROM ubuntu
RUN apt-get -y update && apt-get -y upgrade

RUN apt-get -y install vim tree iproute2 curl w3m ncat less procps
RUN apt-get -y install openjdk-21-jdk git openssh-server
RUN apt-get -y install sudo unminimize
RUN echo y | unminimize
RUN apt-get -y install build-essential
RUN apt-get -y install net-tools iputils-ping
RUN apt-get -y install imagemagick
RUN apt-get -y install redis-tools
RUN apt-get -y install wrk

COPY myinit.sh /usr/bin/
RUN useradd -m -s /bin/bash user
RUN usermod -aG sudo user
COPY 050_sudo_general /etc/sudoers.d/
# prepare ssh
RUN sudo -u user ssh-keygen -q -N '' -t ed25519 -f /home/user/.ssh/id_ed25519 
# install nvm, npm and node for playwright
#RUN sudo -i -u user bash -c "curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.1/install.sh | bash"
RUN curl -fsSL https://deb.nodesource.com/setup_23.x -o nodesource_setup.sh
RUN bash nodesource_setup.sh
RUN apt-get install -y nodejs 
# install deps for playwright
RUN npx playwright install-deps
COPY run-playwright-demo.sh /home/user/
RUN chown user:user /home/user/run-playwright-demo.sh
# install k6
COPY install-k6.sh /usr/bin
RUN /usr/bin/install-k6.sh


CMD ["/usr/bin/myinit.sh"]

