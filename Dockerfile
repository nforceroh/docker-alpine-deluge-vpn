FROM nforceroh/docker-alpine-base

MAINTAINER Sylvain Martin (sylvain@nforcer.com)

ENV UMASK=000
ENV PUID=3001
ENV PGID=3000


RUN \
  echo "Installing openvpn and deluge" \
  && echo "@testing http://nl.alpinelinux.org/alpine/edge/testing" >> /etc/apk/repositories \
  && apk update \
  && apk add --no-cache boost geoip py2-pip openssl intltool openvpn \
  && apk add --no-cache libtorrent-rasterbar bash py2-pip deluge@testing libtorrent-rasterbar \
  && apk add --no-cache zlib py-setuptools py2-openssl py2-chardet py-twisted py2-mako \
  && pip install --no-cache-dir \
        pyxdg service_identity incremental constantly packaging automat \
#  && wget -qO- \
#        http://download.deluge-torrent.org/source/deluge-${DELUGE_VERSION}.tar.gz | tar xz  \
#    cd \
#        deluge-${DELUGE_VERSION}/ && \
#    python setup.py -q build && \
#    python setup.py -q install && \
#    /usr/bin/deluge-web \
#        -f -c ${D_DIR}/config -l ${D_DIR}/config/deluge-web-init.log -L debug && \
#    sleep 10 && \
#    pkill -15 python && \
#    apk del \
##        .libtorrent .build && \
#    rm -rf \
#        /usr/lib/python2.7/site-packages/deluge-${DELUGE_VERSION}-py2.7.egg/share/* \
#        /usr/lib/python2.7/site-packages/deluge-${DELUGE_VERSION}-py2.7.egg/deluge/data/pixmaps/* \
#        /usr/lib/python2.7/site-packages/deluge-${DELUGE_VERSION}-py2.7.egg/deluge/ui/gtkui/* \
#        /usr/lib/python2.7/site-packages/deluge-${DELUGE_VERSION}-py2.7.egg/deluge/ui/console/* \
#        /usr/lib/python2.7/site-packages/deluge-${DELUGE_VERSION}-py2.7.egg/deluge/ui/i18n/* \
#        /usr/bin/deluge /usr/bin/deluged /usr/bin/deluge-gtk
  && echo "Cleaning up" \
  && rm -rf /var/cache/apk/*

COPY rootfs/ /

VOLUME /config

VOLUME /data

EXPOSE 8112
