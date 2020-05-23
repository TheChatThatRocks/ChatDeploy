#!/bin/sh

export original=$(cat /etc/hostname)
sudo hostname $original-worker
echo $original-worker | sudo tee /etc/hostname

# Docker installation
sudo apt-get update

sudo apt-get install -y \
    apt-transport-https \
    ca-certificates \
    curl \
    gnupg-agent \
    software-properties-common

curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -


sudo add-apt-repository \
   "deb [arch=amd64] https://download.docker.com/linux/ubuntu \
   $(lsb_release -cs) \
   stable"

sudo apt-get update
sudo apt-get install -y docker-ce docker-ce-cli containerd.io docker-compose

# Uncomment for slave node
docker swarm join --advertise-addr $(curl http://169.254.169.254/latest/meta-data/public-ipv4) --token SWMTKN-1-5gkiv883t62apgt9keqrjxcv0ynxq61g47g6kbfbzm7t3cil3n-75ur2vjmai5viihwzo41ubo8c 172.31.73.104:2377
