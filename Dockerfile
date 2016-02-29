FROM jenkins:latest

MAINTAINER Louis Amoros <amoros.louis@gmail.com>

ENV DEBIAN_FRONTEND noninteractive
USER root

# install docker
RUN curl -sSL https://get.docker.com/ | sh && rm -rf /var/lib/apt/lists/*

# copy script to execute when jenkins docker is launch
COPY jenkins-cdb-script.sh /usr/share/jenkins/jenkins-cdb-script.sh

# copy job cdb config
COPY cdb /var/jenkins_home/jobs/cdb

# copy and install jenkins plugins
COPY plugins.txt /usr/share/jenkins/plugins.txt
RUN /usr/local/bin/plugins.sh /usr/share/jenkins/plugins.txt

# information to link jenkins docker to docker in docker
ENV DOCKER_HOST tcp://dind-cdb:5000

