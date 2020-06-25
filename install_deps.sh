#!/bin/bash

# This setup script has been tested under Ubuntu 18.04 LTS Server
# Installs Docker, Python 2, and Node.js.
# Adds active user to the docker group.
# Active user must have sudo access.


# Install Docker
sudo apt-get install \
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
sudo apt-get install docker-ce docker-ce-cli containerd.io 

sudo usermod -aG docker etag


# Install Python
sudo apt-get install python cookiecutter


#Install Node
mkdir ~/node ~/bin
cd ~/node
curl -fsSL https://nodejs.org/dist/v12.17.0/node-v12.17.0-linux-x64.tar.xz | tar -xJf -
cd ~/bin
ln -s ~/node/node-v12.17.0-linux-x64/bin/node node
ln -s ~/node/node-v12.17.0-linux-x64/bin/npm npm
ln -s ~/node/node-v12.17.0-linux-x64/bin/npx npx
