#!/usr/bin/env bash
set -e

sudo -v

# Symlink for .config
ln -s ~/dotfiles/.config ~/.config


# Yazi
curl -fsSL https://yazi-rs.github.io/builds/yazi-keyring.gpg | sudo tee /usr/share/keyrings/yazi-keyring.gpg >/dev/null
echo 'deb [signed-by=/usr/share/keyrings/yazi-keyring.gpg] https://yazi-rs.github.io/builds/ stable main' | sudo tee /etc/apt/sources.list.d/yazi.list >/dev/null
sudo apt update && sudo apt install yazi -y

# Neovim
sudo snap install nvim --classic

# Zoxide
curl -sSfL https://raw.githubusercontent.com/ajeetdsouza/zoxide/main/install.sh | sh

# Bat
sudo apt install bat -y

# Starship
sudo apt install starship -y

# GitHub CLI
(type -p wget >/dev/null || (sudo apt update && sudo apt install wget -y)) \
	&& sudo mkdir -p -m 755 /etc/apt/keyrings \
	&& out=$(mktemp) && wget -nv -O$out https://cli.github.com/packages/githubcli-archive-keyring.gpg \
	&& cat $out | sudo tee /etc/apt/keyrings/githubcli-archive-keyring.gpg > /dev/null \
	&& sudo chmod go+r /etc/apt/keyrings/githubcli-archive-keyring.gpg \
	&& sudo mkdir -p -m 755 /etc/apt/sources.list.d \
	&& echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/githubcli-archive-keyring.gpg] https://cli.github.com/packages stable main" | sudo tee /etc/apt/sources.list.d/github-cli.list > /dev/null \
	&& sudo apt update \
	&& sudo apt install gh -y
gh auth login
pushd ~/dotfiles
git remote set-url origin git@github.com:Kapparina/dotfiles.git
popd


# Fish shell
sudo add-apt-repository ppa:fish-shell/release-4
sudo apt install fish -y
command -v fish | sudo tee -a /etc/shells
chsh -s "$(command -v fish)"
# Finishing setup for Zoxide
fish command fish_add_path ~/.local/bin

# Finishing up
sudo apt update
sudo apt upgrade
sudo apt autoremove
