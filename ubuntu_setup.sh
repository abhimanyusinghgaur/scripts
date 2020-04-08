#!/bin/sh
set -ex

# Get user input
read -p "Enter your name for git config: " git_username
read -p "Enter your email for git config: " git_email

# initial update
sudo apt update

# must haves
sudo apt install -y vim git curl xclip

# setup git with ssh
git config --global user.name $git_username 
git config --global user.email $git_email
ssh-keygen -t rsa -b 4096 -C "$git_email"
eval "$(ssh-agent -s)"
ssh-add ~/.ssh/id_rsa

# build Essentials
sudo apt install -y build-essential

# Languages 
sudo apt install -y gcc g++ default-jre default-jdk python3 python3-pip nodejs npm node-grunt-cli

# build tools
sudo apt install -y make maven

# Cool terminal
sudo apt install -y tilix

# sublime text
wget -qO - https://download.sublimetext.com/sublimehq-pub.gpg | sudo apt-key add -
sudo apt install apt-transport-https
echo "deb https://download.sublimetext.com/ apt/stable/" | sudo tee /etc/apt/sources.list.d/sublime-text.list
sudo apt update
sudo apt install -y sublime-text

# Docker
curl -fsSL https://get.docker.com -o get-docker.sh
sudo sh get-docker.sh
sudo apt install -y docker-compose
sudo usermod -aG docker $(whoami) # use Docker as a non-root user, adding your user to the “docker” group

# some softwares
sudo snap install vlc
sudo snap install spotify

# IDEs and tools
sudo snap install postman
sudo snap install slack
sudo snap install goland
# below ones may require --classic flag
sudo snap install webstorm
sudo snap install code  # vscode
