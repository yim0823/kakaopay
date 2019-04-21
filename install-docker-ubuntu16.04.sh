#!/bin/sh

set -xe

# Update apt sources
sudo apt-get update
sudo apt-get install apt-transport-https ca-certificates

# Add GPG key
sudo apt-key adv --keyserver hkp://p80.pool.sks-keyservers.net:80 --recv-keys 58118E89F3A912897C070ADBF76221572C52609D
sudo sh -c 'echo "deb https://apt.dockerproject.org/repo ubuntu-xenial main" > /etc/apt/sources.list.d/docker.list'

# Upgrades apt packages
sudo apt-get update

# Remove old repo
sudo apt-get purge lxc-docker

# Verify the correct repo
sudo apt-cache policy docker-engine

# Install linux-image-extra package
sudo apt-get install -y linux-image-extra-$(uname -r)

# Install docker python-pip
sudo apt-get install -y docker-engine

# Install basic packages
sudo apt-get install -y python-pip git curl build-essential

# Start docker & create group & add group account
sudo service docker start
sudo systemctl enable docker
sudo groupadd docker
sudo usermod -aG docker $(whoami)

echo "Docker engine installed"

COMPOSE_VERSION=`git ls-remote https://github.com/docker/compose | grep refs/tags | grep -oP "[0-9]+\.[0-9]+\.[0-9]+$" | tail -n 1`
sudo sh -c "curl -L https://github.com/docker/compose/releases/download/${COMPOSE_VERSION}/docker-compose-`uname -s`-`uname -m` > /usr/local/bin/docker-compose"
sudo chmod +x /usr/local/bin/docker-compose
sudo sh -c "curl -L https://raw.githubusercontent.com/docker/compose/${COMPOSE_VERSION}/contrib/completion/bash/docker-compose > /etc/bash_completion.d/docker-compose"

echo "Docker compose ${COMPOSE_VERSION} installed"

# Create directory and clone git repository
mkdir -p /usr/app
cd /usr/app
git clone https://github.com/yim0823/kakaopay.git
