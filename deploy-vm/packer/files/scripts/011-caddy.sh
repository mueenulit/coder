#!/bin/sh

# install Caddy
sudo apt-get install -y debian-keyring debian-archive-keyring apt-transport-https
curl -1sLf 'https://dl.cloudsmith.io/public/caddy/stable/gpg.key' | sudo tee /etc/apt/trusted.gpg.d/caddy-stable.asc
curl -1sLf 'https://dl.cloudsmith.io/public/caddy/stable/debian.deb.txt' | sudo tee /etc/apt/sources.list.d/caddy-stable.list
sudo apt-get update
DEBIAN_FRONTEND=noninteractive sudo apt-get install caddy

sudo groupadd --system caddy
sudo useradd --system \
    --gid caddy \
    --create-home \
    --home-dir /var/lib/caddy \
    --shell /usr/sbin/nologin \
    --comment "Caddy web server" \
    caddy

sudo chown root:root /usr/bin/caddy
sudo chmod 755 /usr/bin/caddy
sudo mkdir /etc/caddy
sudo chown -R root:caddy /etc/caddy
sudo mkdir /etc/ssl/caddy
sudo chown -R root:caddy /etc/ssl/caddy
sudo chmod 0770 /etc/ssl/caddy
sudo touch /etc/caddy/Caddyfile
sudo sh -c 'curl https://raw.githubusercontent.com/caddyserver/dist/master/init/caddy.service > /etc/systemd/system/caddy.service'
sudo chmod 644 /etc/systemd/system/caddy.service
sudo systemctl daemon-reload
sudo systemctl status caddy
sudo systemctl enable --now caddy