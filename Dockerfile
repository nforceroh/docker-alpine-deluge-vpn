FROM nforceroh/docker-alpine-base

MAINTAINER Sylvain Martin (sylvain@nforcer.com)

ENV UMASK=000
ENV PUID=3001
ENV PGID=3000
# logging levels none, critical, error, warning, info, info
ENV DELUGE_LOGGING=info
ENV DELUGE_MOVE_COMPLETED=/data/done
ENV DELUGE_TORRENT_LOCATION=/data/torrents
ENV DELUGE_DOWNLOAD_WORK=/data/work
ENV DELUGE_AUTOADD_LOCATION=/data/incoming
ENV DELUGE_LISTEN_PORT=8080,8080
ENV PYTHON_EGG_CACHE=/config/plugins/

RUN \
  echo "Installing openvpn and deluge" \
  && echo "@testing http://nl.alpinelinux.org/alpine/edge/testing" >> /etc/apk/repositories \
  && apk update \
  && apk --no-cache add py2-pip boost geoip intltool openvpn shadow bash deluge@testing \
  && apk --no-cache --virtual=build-dependencies \
	add openssl-dev gcc python-dev musl-dev libffi-dev \
  && pip install --upgrade pip \
  && pip install cryptography==2.1.4 service_identity pyopenssl==17.5.0 incremental constantly packaging automat MarkupSafe \
  && apk del --purge build-dependencies \
  && echo "Cleaning up" \
  && rm -rf /var/cache/apk/* /root/.cache /tmp/*

VOLUME /config
EXPOSE 8112
COPY rootfs/ /
