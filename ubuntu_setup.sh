#!/bin/sh
set -e

# Get user input
read -p "Enter your name for git config: " git_username
read -p "Enter your email for git config: " git_email
read -p "Install Java 8 instead of latest? [Y/n] " install_java_8

# Set which java to install
if [ "$install_java_8" = "Y" -o  "$install_java_8" = "y" ]
then
	java="openjdk-8-jdk openjdk-8-jre"
else
	java="default-jdk default-jre"
fi

# initial update
echo "Updating system ..."
sudo apt update
echo "Done!" && echo

# must haves
echo "Installing vim git curl xclip jq ..."
sudo apt install -y vim git curl xclip jq
echo "Done!" && echo

# setup git with ssh
echo "Setting up git with ssh ..."
git config --global user.name $git_username 
git config --global user.email $git_email
ssh-keygen -t rsa -b 4096 -C "$git_email"
eval "$(ssh-agent -s)"
ssh-add ~/.ssh/id_rsa
echo "Done!" && echo

# build Essentials
echo "Installing build-essentials ..."
sudo apt install -y build-essential
echo "Done!" && echo

# Languages 
echo "Installing gcc g++ $java python3 python3-pip nodejs npm node-grunt-cli ..."
sudo apt install -y gcc g++ $java python3 python3-pip nodejs npm node-grunt-cli
echo "Done!" && echo


# build tools
echo "Installing make maven ..."
sudo apt install -y make maven
echo "Done!" && echo

# Cool terminal
echo "Installing tilix ..."
sudo apt install -y tilix
echo "Done!" && echo

# sublime text
echo "Installing sublime-text ..."
wget -qO - https://download.sublimetext.com/sublimehq-pub.gpg | sudo apt-key add -
sudo apt install apt-transport-https
echo "deb https://download.sublimetext.com/ apt/stable/" | sudo tee /etc/apt/sources.list.d/sublime-text.list
sudo apt update
sudo apt install -y sublime-text
echo "Done!" && echo

# Docker
echo "Installing Docker ..."
curl -fsSL https://get.docker.com -o get-docker.sh
sudo sh get-docker.sh
sudo apt install -y docker-compose
sudo usermod -aG docker $(whoami) # use Docker as a non-root user, adding your user to the “docker” group
echo "Done!" && echo

# Protocol-Buffers
echo "Installing latest Protobuf compiler ..."
pb_ver_latest=$(curl -fsSL https://api.github.com/repos/protocolbuffers/protobuf/releases/latest | jq '.tag_name' | cut -d "\"" -f2)
pb_ver_latest="${pb_ver_latest#?}"
pb_path=protoc-$pb_ver_latest-linux-x86_64
echo "Downloading protoc: v$pb_ver_latest ..."
curl -fsSL https://github.com/protocolbuffers/protobuf/releases/download/v$pb_ver_latest/$pb_path.zip -o $pb_path.zip
echo "Download complete!"
unzip -q $pb_path.zip -d $pb_path/
sudo cp $pb_path/bin/. /usr/local/bin/ -r
sudo cp $pb_path/include/. /usr/local/include/ -r
rm -rf $pb_path $pb_path.zip
echo "Protobuf compiler installed successfully!"

# some softwares
echo "Installing vlc ..."
sudo snap install vlc
echo "Done!" && echo "Installing spotify ..."
sudo snap install spotify
echo "Done!"

# IDEs and tools
echo "Installing postman ..."
sudo snap install postman
echo "Done!" && echo "Installing slack ..."
sudo snap install slack
echo "Done!" && echo "Installing goland ..."
sudo snap install goland
echo "Done!" && echo "Installing webstorm ..."
# below ones may require --classic flag
sudo snap install webstorm
echo "Done!" && echo "Installing vscode ..."
sudo snap install code  # vscode
echo "Done!" && echo

# Add enviornment variables
echo "export JAVA_HOME=/usr/lib/jvm/$(update-java-alternatives -l | cut -d " " -f1)" >> ~/.profile
echo "Added JAVA_HOME environment variable" && echo

echo "You may want to install Go, Google Chrome and Zoom by yourself!"
echo "Don't forget to restart the system."
