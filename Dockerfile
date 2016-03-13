##set base image as debian
FROM armv7/armhf-debian
MAINTAINER Ben El-Baz
USER root

##install all required libraries and dependancies, install docker
RUN cd /etc && { curl -O https://raw.githubusercontent.com/1elbaz/chipplay/master/sources.list > sources.list ; cd - ; }
RUN apt-get -y update
RUN apt-get -y install docker.io
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

##clone into AirPlay code git repo, run configuration, and compile
RUN git clone https://github.com/mikebrady/shairport-sync
RUN cd shairport-sync
RUN autoreconf -i -f
RUN ./configure --with-alsa --with-avahi --with-ssl=openssl --with-metadata --with-soxr --with-systemd
RUN make

##set permissions and install
RUN getent group shairport-sync &>/dev/null || sudo groupadd -r shairport-sync >/dev/null
RUN getent passwd shairport-sync &> /dev/null || sudo useradd -r -M -g shairport-sync -s /usr/bin/nologin chipplayref2
RUN make install

##download configuration files into docker image, including the config file that starts shairport-sync at boot
RUN cd - && cd /etc && { curl -O https://raw.githubusercontent.com/1elbaz/chipplay/master/shairport-sync.conf > shairport-sync.conf }
RUN curl -O https://raw.githubusercontent.com/1elbaz/chipplay/master/rc.local > rc.local && cd -
