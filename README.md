# docker-alpine-deluge-vpn
My tweaked image with NFS support

docker create \
  --restart always \
  --cap-add=NET_ADMIN \
  --name deluge \
  --cpus=1 \
  --memory=1g \
  -p 8112:8112 \
  -v deluge_cfg:/config \
  -e TZ=America/New_York \
  -e VPN_ENABLED=yes \
  -e VPN_USER=XXXXX \
  -e VPN_PASS=XXXXX \
  -e VPNCONFIG=United-States-Atlanta.ovpn \
  -e LAN_NETWORK=10.0.0.0/22 \
  -e NAME_SERVERS=8.8.8.8,1.1.1.1 \
  -e ENABLE_NFS=true \
  -e NFSSHARE1=10.0.0.100:/mnt/p2p/torrent:/data \
  -e UMASK=000 \
  -e PUID=3001 \
  -e PGID=3000 \
  --network traefik_webgateway \
  -l traefik.enable=true \
  -l traefik.backend=deluge \
  -l traefik.frontend.rule=Host:XXXXX.example.com \
  -l traefik.docker.network=traefik_webgateway \
  -l traefik.port=8112 \
   nforceroh/docker-arch-deluge-vpn
docker start deluge
