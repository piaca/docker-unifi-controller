FROM ghcr.io/linuxserver/baseimage-ubuntu:focal

# set version label
LABEL maintainer="aptalca"

# environment settings
ARG DEBIAN_FRONTEND="noninteractive"
ARG TZ="Asia/Shanghai"

RUN \
  echo "**** install packages ****" && \
  apt-get update && \
  apt-get install -y \
  apt-transport-https \
    tzdata \
    curl \
    wget && \
  echo "**** unifi repo settings ****" && \
  echo 'deb https://www.ui.com/downloads/unifi/debian stable ubiquiti' | tee /etc/apt/sources.list.d/100-ubnt-unifi.list && \
  wget -O /etc/apt/trusted.gpg.d/unifi-repo.gpg https://dl.ui.com/unifi/unifi-repo.gpg && \
  echo "**** install unifi ****" && \
  apt-get update && \
  DEBIAN_FRONTEND=noninteractive apt-get install -y unifi && \
  echo "**** cleanup ****" && \
  apt-get clean && \
  rm -rf \
    /tmp/* \
    /var/lib/apt/lists/* \
    /var/tmp/*

#add local files
COPY root/ /

# Volumes and Ports
WORKDIR /usr/lib/unifi
VOLUME /config
EXPOSE 8080 8443 8843 8880