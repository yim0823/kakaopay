#!/bin/sh

set -xe

# Remove old version docker
sudo apt-get remove docker docker-engine docker.io

# Update apt sources
sudo apt-get update
sudo apt-get install apt-transport-https ca-certificates curl gnupg-agent software-properties-common

# Add Docker’s official GPG key
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
sudo apt-key fingerprint 0EBFCD88 | grep docker@docker.com || exit 1
sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"
 
# Upgrades apt packages
sudo apt-get update

# Verify the correct repo
sudo apt-cache policy docker-engine

# Install linux-image-extra package
#sudo apt-get install -y linux-image-extra-$(uname -r)

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

# download the current stable release of Docker Compose
sudo curl -L "https://github.com/docker/compose/releases/download/1.24.0/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose

# Apply executable permissions to the binary
sudo chmod +x /usr/local/bin/docker-compose

# make link
sudo ln -s /usr/local/bin/docker-compose /usr/bin/docker-compose

echo "Docker compose installed"

# Create directory and clone git repository
sudo mkdir -p /usr/app
cd /usr/app
sudo git clone https://github.com/yim0823/kakaopay.git
