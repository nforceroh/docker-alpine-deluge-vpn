FROM nforceroh/d_alpine-s6:edge

MAINTAINER Sylvain Martin (sylvain@nforcer.com)

ENV UMASK=000
ENV PUID=3001
ENV PGID=3000
# logging levels none, debug, critical, error, warning, info
ENV DELUGE_LOGGING=info
ENV DELUGE_MOVE_COMPLETED=/data/done
ENV DELUGE_TORRENT_LOCATION=/data/torrents
ENV DELUGE_DOWNLOAD_WORK=/data/work
ENV DELUGE_AUTOADD_LOCATION=/data/incoming
ENV DELUGE_LISTEN_PORT=8080,8080
ENV PYTHON_EGG_CACHE=/config/plugins/
ENV VPNCONFIG="TorGuard.USA-NEW-YORK.ovpn"

RUN \
  echo "Installing openvpn and deluge" \
  && apk update \
  && apk upgrade \
  && apk add --no-cache python3 py3-pip boost geoip intltool openvpn shadow bash bind-tools deluge \
  && apk add --no-cache --virtual .pip-build-deps make gcc g++ autoconf python3-dev libffi-dev libressl-dev \
  && pip3 install automat incremental constantly service_identity packaging automat MarkupSafe \
  && apk del .pip-build-deps \
  && cd /tmp; wget https://torguard.net/downloads/OpenVPN-UDP-Standard.zip \
  && unzip -j OpenVPN-UDP-Standard.zip -d /etc/openvpn \
  && rm -rf /var/cache/apk/* /root/.cache /tmp/*

VOLUME /config
EXPOSE 8112
COPY rootfs/ /
ENTRYPOINT [ "/init" ]