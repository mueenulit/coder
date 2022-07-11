#!/bin/sh

# allow us to access systemd logs
mkdir -p /var/log/journal
systemctl force-reload systemd-journald
systemctl restart systemd-journald

# create a coder user
adduser --disabled-password --gecos "" coder
echo "coder ALL=(ALL:ALL) NOPASSWD: ALL" | sudo tee /etc/sudoers.d/coder
usermod -aG sudo coder

# copy ssh keys from root
cp -r /root/.ssh /home/coder/.ssh
chown -R coder:coder /home/coder/.ssh

# install code-server
su coder
cd $HOME
curl -fOL https://github.com/coder/code-server/releases/download/v4.0.2/code-server_4.0.2_amd64.deb
sudo dpkg -i code-server_4.0.2_amd64.deb
sudo systemctl enable --now code-server@$USER

# add default password
mkdir -p /home/coder/.config/code-server
touch /home/coder/.config/code-server/config.yaml
echo "password: true" > /home/coder/.config/code-server/config.yaml
chown -R coder:coder /home/coder/.config

exit