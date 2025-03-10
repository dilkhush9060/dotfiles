#!/bin/bash

# Exit on any error
set -e

# Colors for output
GREEN='\033[0;32m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

echo -e "${BLUE}Starting Ubuntu Professional Setup...${NC}"

# Update system
echo -e "${GREEN}Updating system packages...${NC}"
apt update && apt upgrade -y

# Install Nala
echo -e "${GREEN}Installing Nala package manager...${NC}"
apt install -y nala

# Install essential tools
echo -e "${GREEN}Installing essential development tools...${NC}"

nala install -y \
    git\
    curl\
    build-essential\
    wget\
    vim\
    nano\
    btop\
    unzip\
    ufw\
    stow\
    synaptic\
    gdebi\
    preload\
    gnome-tweak-tool\
    gnome-shell-extension-manager\
    neofetch\
    bpytop\
    libc6-i386\
    libc6-x32\
    libu2f-udev\
    samba-common-bin\
    exfat-fuse\
    unrar\
    linux-headers-$(uname -r)\
    linux-headers-generic\
    ntfs-3g\
    p7zip\
    make\
    bzip2\
    tar\
    vlc\
    tmux\
    ubuntu-restricted-extras\
    fd-find\
    fzf\
    zoxide\
    openjdk-17-jdk\
    ripgrep\
    coreutils\




# Configure Git
echo -e "${GREEN}Configuring Git...${NC}"
git config --global core.editor "vim"
git config --global init.defaultBranch main

# Clean up
echo -e "${GREEN}Cleaning up...${NC}"
nala autoremove -y


#firewall config
systemctl enable ufw
systemctl start ufw
ufw deny 22/tcp

#starship
curl -sS https://starship.rs/install.sh | sh


# Fetch the latest version from GitHub
LATEST_VERSION=$(curl -s https://api.github.com/repos/ogham/exa/releases/latest | grep '"tag_name":' | sed -E 's/.*"tag_name": "([^"]+)".*/\1/')

if [ -z "$LATEST_VERSION" ]; then
    echo "Failed to fetch the latest version. Please check your internet connection or the GitHub API."
    exit 1
fi

echo "Installing exa version: $LATEST_VERSION"

# Download the latest binary for Linux x86_64
curl -LO "https://github.com/ogham/exa/releases/download/${LATEST_VERSION}/exa-linux-x86_64-${LATEST_VERSION}.zip"

# Check if unzip is installed
if ! command -v unzip &> /dev/null; then
    echo "unzip is required. Installing it now..."
    sudo apt update && sudo apt install -y unzip
fi

# Extract the zip
unzip "exa-linux-x86_64-${LATEST_VERSION}.zip"

# Move to /usr/local/bin
sudo mv bin/exa /usr/local/bin/exa

# Set executable permissions
sudo chmod +x /usr/local/bin/exa

# Clean up
rm -rf bin "exa-linux-x86_64-${LATEST_VERSION}.zip"

# Verify
if command -v exa &> /dev/null; then
    exa --version
    echo "exa installed successfully!"
else
    echo "Installation failed. Please check the steps above."
    exit 1
fi

#setup nvim
# curl -LO https://github.com/neovim/neovim/releases/latest/download/nvim-linux-x86_64.tar.gz
# rm -rf /opt/nvim
# tar -C /opt -xzf nvim-linux-x86_64.tar.gz
# rm -rf nvim-linux-x86_64.tar.gz


#stow start
cd "$HOME" && cd dotfiles && stow .



echo -e "${BLUE}Setup complete! Please restart your terminal or reboot the system.${NC}"
echo -e "${GREEN}Installed components:${NC}"