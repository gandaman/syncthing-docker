# Docker container for Syncthing
#
# ... forked from ptimof/syncthing

FROM phusion/baseimage:0.9.17

ENV DEBIAN_FRONTEND noninteractive

# add syncthing user (Note: must match uid/gid on host computer)
RUN groupadd -g 800 syncthing && \
    useradd -m -u 800 -g 800 syncthing

# create binary directory that's r/w by syncthing
RUN mkdir -p /srv && \
    chown syncthing:syncthing /srv

# Version of Syncthing to retrieve
# This is a crazy way of updating, but it is early in the dev cycle
ENV VERSION 0.12.16

# get binary from official distro
WORKDIR /tmp

RUN curl -# -L -O https://github.com/syncthing/syncthing/releases/download/v${VERSION}/syncthing-linux-amd64-v${VERSION}.tar.gz && \
        tar xf syncthing-linux-amd64-v${VERSION}.tar.gz && \
        cp syncthing-linux-amd64-v${VERSION}/syncthing /srv && \
        rm -r syncthing-linux-amd64-v${VERSION}.tar.gz syncthing-linux-amd64-v${VERSION}

# add in launch script
ADD syncthingd /srv/syncthingd
RUN chmod 755 /srv/syncthingd

# change ownership to syncthing
RUN chown syncthing:syncthing /srv/*

# run as syncthing
USER syncthing
WORKDIR /home/syncthing

# config and initial sync directories in ~syncthing
VOLUME ["/home/syncthing"]

EXPOSE 8000 22000 21025/udp

CMD [ "--no-browser", "--no-restart", "--gui-address", "https://0.0.0.0:8080" ]

ENTRYPOINT ["/srv/syncthingd"]
