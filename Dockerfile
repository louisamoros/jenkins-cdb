FROM jenkins:latest

MAINTAINER Louis Amoros <amoros.louis@gmail.com>

ENV DEBIAN_FRONTEND noninteractive
USER root
RUN curl -sSL https://get.docker.com/ | sh && rm -rf /var/lib/apt/lists/*

COPY plugins.txt /usr/share/jenkins/plugins.txt
RUN /usr/local/bin/plugins.sh /usr/share/jenkins/plugins.txt

ENV DOCKER_HOST tcp://dind-cdb:5000

