#!/bin/sh

set -xe

# Update apt sources
sudo apt-get update
sudo apt-get install apt-transport-https ca-certificates curl gnupg-agent software-properties-common

# Add Docker’s official GPG key
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
sudo apt-key fingerprint 0EBFCD88 | grep docker@docker.com || exit 1
sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"
 
# Upgrades apt packages
sudo apt-get update

# Remove old repo
sudo apt-get purge lxc-docker

# Verify the correct repo
sudo apt-cache policy docker-engine

# Install linux-image-extra package
sudo apt-get install -y linux-image-extra-$(uname -r)

# Install docker python-pip
sudo apt-get install -y docker-ce

# Install basic packages
sudo apt-get install -y python-pip git build-essential

# Start docker & create group & add group account
sudo service docker start
sudo systemctl enable docker
sudo groupadd docker
sudo usermod -aG docker $(whoami)
sudo systemctl restart docker

sudo systemctl start docker.service
sudo systemctl enable docker.service

echo "Docker-ce installed"

sudo apt-get install -y docker-compose
echo "Docker compose installed"

# Create directory and clone git repository
mkdir -p /usr/app
cd /usr/app
git clone https://github.com/yim0823/kakaopay.git
