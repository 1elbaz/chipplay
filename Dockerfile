FROM armv7/armhf-debian
MAINTAINER Ben El-Baz
USER root

RUN apt-get -y update
RUN apt-get -y install curl
RUN apt-get –y install build-essential
RUN apt-get –y install git
RUN apt-get –y install autoconf
RUN apt-get –y install libtool
RUN apt-get –y install libdaemon-dev
RUN apt-get –y install libasound2-dev
RUN apt-get –y install libconfig-dev
RUN apt-get –y install libavahi-client-dev
RUN apt-get –y install libpopt-dev
RUN apt-get –y install libssl-dev
RUN apt-get –y install libsoxr-dev

RUN git clone https://github.com/mikebrady/shairport-sync
RUN cd shairport-sync
RUN autoreconf -i -f
RUN ./configure --with-alsa --with-avahi --with-ssl=openssl --with-metadata --with-soxr --with-systemd
RUN make

RUN getent group shairport-sync &>/dev/null || sudo groupadd -r shairport-sync >/dev/null
RUN getent passwd shairport-sync &> /dev/null || sudo useradd -r -M -g shairport-sync -s /usr/bin/nologin chipplayref2

RUN cd - && cd /etc && { curl 
