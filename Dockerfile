##set base image as debian
FROM armv7/armhf-debian
MAINTAINER Ben El-Baz
USER root

##install all required libraries and dependancies, install docker
RUN apt-get -y update && apt-get -y install  \ 
    curl \
&& rm -rf /var/lib/apt/lists/*

RUN cd /etc/apt && { curl -O https://raw.githubusercontent.com/1elbaz/chipplay/master/sources.list > sources.list ; cd -- ; }
RUN apt-get -y update && apt-get -y install \
    docker.io \
    build-essential \
    dh-autoreconf \
    git \
    autoconf \
    avahi-daemon \
    avahi-discover \
    avahi-utils \
    libnss-mdns \
    libtool \
    libdaemon-dev \
    libasound2-dev \
    libconfig-dev \
    libavahi-client-dev \
    libavahi-core-dev \
    libpopt-dev \
    libssl-dev \
    libsoxr-dev \
&& rm -rf /var/lib/apt/lists/*

##clone into AirPlay code git repo, run configuration, and compile
RUN git clone https://github.com/mikebrady/shairport-sync
RUN cd shairport-sync &&  autoreconf -i -f &&  ./configure --with-alsa --with-avahi --with-ssl=openssl --with-metadata --with-soxr --with-systemd && make && { getent group shairport-sync &>/dev/null || sudo groupadd -r shairport-sync >/dev/null ;  getent passwd shairport-sync &> /dev/null || sudo useradd -r -M -g shairport-sync -s /usr/bin/nologin chipplayref2 ; } && make install

##download configuration files into docker image, including the config file that starts shairport-sync at boot
RUN cd - && cd /etc && { curl -O https://raw.githubusercontent.com/1elbaz/chipplay/master/shairport-sync.conf > shairport-sync.conf ; }
RUN curl -O https://raw.githubusercontent.com/1elbaz/chipplay/master/rc.local > rc.local && cd -

##execute shairport-sync process 
CMD shairport-sync
