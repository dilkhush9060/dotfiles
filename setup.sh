#!/bin/bash

# Exit on any error
set -e

# Colors for output
GREEN='\033[0;32m'
BLUE='\033[0;34m'
NC='\033[0m'

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

#nvm and node
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.1/install.sh | bash
nvm install --lts
npm i -g npm@latest
npm i -g pnpm
pnpm setup

# Fetch the latest version from GitHub
LATEST_VERSION=$(curl -s https://api.github.com/repos/ogham/exa/releases/latest | grep '"tag_name":' | sed -E 's/.*"tag_name": "([^"]+)".*/\1/')
if [ -z "$LATEST_VERSION" ]; then
    echo "Failed to fetch the latest version. Please check your internet connection or the GitHub API."
    exit 1
fi
echo "Installing exa version: $LATEST_VERSION"
curl -LO "https://github.com/ogham/exa/releases/download/${LATEST_VERSION}/exa-linux-x86_64-${LATEST_VERSION}.zip"
if ! command -v unzip &> /dev/null; then
    echo "unzip is required. Installing it now..."
    sudo apt update && sudo apt install -y unzip
fi
unzip "exa-linux-x86_64-${LATEST_VERSION}.zip"
sudo mv bin/exa /usr/local/bin/exa
sudo chmod +x /usr/local/bin/exa
rm -rf bin "exa-linux-x86_64-${LATEST_VERSION}.zip"
if command -v exa &> /dev/null; then
    exa --version
    echo "exa installed successfully!"
else
    echo "Installation failed. Please check the steps above."
    exit 1
fi

#setup rustup
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh

# Set Lua 
wget https://luarocks.org/releases/luarocks-3.11.1.tar.gz
tar zxpf luarocks-3.11.1.tar.gz
cd luarocks-3.11.1
./configure && make && sudo make install
luarocks --version
lua -v
cd ../
rm -rf luarocks-3.11.1.tar.gz
rm -rf luarocks-3.11.1

#setup nvim
NVIM_TAR="nvim-linux-x86_64.tar.gz"
NVIM_DIR="nvim-linux-x86_64"
INSTALL_DIR="/opt/nvim"
curl -LO "https://github.com/neovim/neovim/releases/latest/download/$NVIM_TAR"
sudo rm -rf "$INSTALL_DIR"
tar -xzf "$NVIM_TAR"
sudo mv "$NVIM_DIR" "$INSTALL_DIR"
rm -f "$NVIM_TAR"
"$INSTALL_DIR/bin/nvim" --version

#tpm setup
git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm

#stow start
stow .

# finish
echo -e "${BLUE}Setup complete! Please restart your terminal or reboot the system.${NC}"
echo -e "${GREEN}Installed components:${NC}"