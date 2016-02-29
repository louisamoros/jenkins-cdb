FROM jenkins:latest

MAINTAINER Louis Amoros <amoros.louis@gmail.com>

ENV DEBIAN_FRONTEND noninteractive
USER root

# install docker
RUN curl -sSL https://get.docker.com/ | sh && rm -rf /var/lib/apt/lists/*

# install docker-compose
RUN curl -L https://github.com/docker/compose/releases/download/1.6.2/docker-compose-`uname -s`-`uname -m` > /usr/local/bin/docker-compose

# copy config directory
COPY config /usr/share/jenkins/config

# copy job cdb config
COPY config/cdb /var/jenkins_home/jobs/cdb

# copy and install jenkins plugins
COPY config/plugins.txt /usr/share/jenkins/plugins.txt
RUN /usr/local/bin/plugins.sh /usr/share/jenkins/plugins.txt

# link jenkins docker to dind with port 
ENV DOCKER_HOST tcp://dind-cdb:5000

