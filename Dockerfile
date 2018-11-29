FROM nforceroh/docker-alpine-base

MAINTAINER Sylvain Martin (sylvain@nforcer.com)

ENV UMASK=000
ENV PUID=3001
ENV PGID=3000


RUN \
  echo "Installing openvpn and deluge" \
  && echo "@testing http://nl.alpinelinux.org/alpine/edge/testing" >> /etc/apk/repositories \
  && apk update \
  && apk --no-cache add py2-pip boost geoip intltool openvpn shadow bash deluge@testing \
#  && apk --no-cache --virtual=build-dependencies \
#	add openssl-dev gcc python-dev musl-dev libffi-dev \
#  && pip install --upgrade pip \
#  && pip install cryptography==2.1.4 service_identity pyopenssl==17.5.0 incremental constantly packaging automat MarkupSafe \
#  && apk del --purge \
#	build-dependencies \
#    rm -rf \
#        /usr/lib/python2.7/site-packages/deluge-${DELUGE_VERSION}-py2.7.egg/share/* \
#        /usr/lib/python2.7/site-packages/deluge-${DELUGE_VERSION}-py2.7.egg/deluge/data/pixmaps/* \
#        /usr/lib/python2.7/site-packages/deluge-${DELUGE_VERSION}-py2.7.egg/deluge/ui/gtkui/* \
#        /usr/lib/python2.7/site-packages/deluge-${DELUGE_VERSION}-py2.7.egg/deluge/ui/console/* \
#        /usr/lib/python2.7/site-packages/deluge-${DELUGE_VERSION}-py2.7.egg/deluge/ui/i18n/* \
#        /usr/bin/deluge /usr/bin/deluged /usr/bin/deluge-gtk
  && echo "Cleaning up" \
  && rm -rf /var/cache/apk/* /root/.cache /tmp/* 

#COPY rootfs/ /

VOLUME /config

VOLUME /data

EXPOSE 8112
