#!/bin/bash
set -ex 

yum install epel-release yum-utils -y && \
yum update -y && \
yum install -y curl wget ssmtp && \
curl -sSL https://github.com/just-containers/s6-overlay/releases/download/${S6_OVERLAY_VERSION}/s6-overlay-amd64.tar.gz | tar xvfz - -C /

groupadd -g 911 app && \
useradd -u 911 -g 911 -s /bin/false -m app && \
usermod -G users app && \
mkdir -p /app /config /defaults 
      
chmod -v +x /etc/cont-init.d/*
