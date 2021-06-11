FROM nforceroh/d_alpine-s6:edge

ARG BUILD_DATE
ARG VCS_REF
ARG VERSION

LABEL \
  org.label-schema.build-date=$BUILD_DATE \
  org.label-schema.name="d_alpine-deluge-vpn" \
  org.label-schema.description="deluge docker container with OpenVPN client running as unprivileged user on alpine linux" \
  org.label-schema.url="https://github.com/nforceroh/d_alpine-deluge-vpn" \
  org.label-schema.vcs-ref=$VCS_REF \
  org.label-schema.vcs-url="https://github.com/nforceroh/d_alpine-deluge-vpn" \
  org.label-schema.vendor="nforceroh" \
  org.label-schema.version=$VERSION \
  org.label-schema.schema-version="1.0"

ENV \
  UMASK=000 \
  PUID=3001 \
  PGID=3000 \
  # logging levels none, debug, critical, error, warning, info \
  DELUGE_LOGGING=info \
  DELUGE_MOVE_COMPLETED=/data/done \
  DELUGE_TORRENT_LOCATION=/data/torrents \
  DELUGE_DOWNLOAD_WORK=/data/work \
  DELUGE_AUTOADD_LOCATION=/data/incoming \
  DELUGE_LISTEN_PORT=8080,8080 \
  PYTHON_EGG_CACHE=/config/plugins/ \
  VPNCONFIG="TorGuard.USA-NEW-YORK" 

RUN \
  echo "Installing openvpn and deluge" \
  && apk update \
  && apk upgrade \
  && apk add --no-cache build-base ca-certificates libffi-dev libjpeg-turbo-dev linux-headers p7zip \
      py3-libtorrent-rasterbar py3-openssl py3-pip py3-wheel python3-dev unrar unzip zlib-dev geoip \
      intltool openvpn shadow bash bind-tools deluge \
  && cd /tmp; wget https://torguard.net/downloads/OpenVPN-UDP-Standard.zip \
  && unzip -j OpenVPN-UDP-Standard.zip -d /etc/openvpn \
  && mv /usr/lib/python3.8/site-packages/deluge/ui/web/icons /usr/lib/python3.8/site-packages/deluge/ui/web/icons.bak \
  && mv /usr/lib/python3.8/site-packages/deluge/ui/web/css/deluge.css /usr/lib/python3.8/site-packages/deluge/ui/web/css/deluge.css.bak \
  && wget -c https://github.com/joelacus/deluge-web-dark-theme/raw/main/deluge_web_dark_theme.tar.gz -O - | tar -xz -C /usr/lib/python3.8/site-packages/deluge/ui/web/ \
  && apk del build-base libffi-dev libjpeg-turbo-dev linux-headers py3-wheel python3-dev zlib-dev \
  && rm -rf /var/cache/apk/* /root/.cache /tmp/*

VOLUME /config
EXPOSE 8112
COPY rootfs/ /
ENTRYPOINT [ "/init" ]