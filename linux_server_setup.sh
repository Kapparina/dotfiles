#!/usr/bin/env bash
set -e

sudo -v

export NEEDRESTART_SUSPEND=1

# Symlink for .config
mkdir "$HOME/.config"
source="$HOME/dotfiles/.config"
destination="$HOME/.config"
shopt -s dotglob
for item in "$source"/*; do
    ln -s "$item" "$destination/"
done

# Eza
sudo apt install eza

# Yazi
curl -fsSL https://yazi-rs.github.io/builds/yazi-keyring.gpg | sudo tee /usr/share/keyrings/yazi-keyring.gpg >/dev/null
echo 'deb [signed-by=/usr/share/keyrings/yazi-keyring.gpg] https://yazi-rs.github.io/builds/ stable main' | sudo tee /etc/apt/sources.list.d/yazi.list >/dev/null
sudo apt update && sudo apt install yazi -y
# Yazi optionals
sudo apt install fzf ripgrep jq fd-find ffmpeg -y

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
if ! gh auth status &>/dev/null; then
    GH_BROWSER=/bin/true gh auth login --git-protocol ssh
fi
pushd ~/dotfiles
git remote set-url origin git@github.com:Kapparina/dotfiles.git
popd

# Docker
sudo apt remove $(dpkg --get-selections docker.io docker-compose docker-compose-v2 docker-doc docker-buildx podman-docker containerd runc | cut -f1)
# Add Docker's official GPG key:
sudo apt update
sudo apt install ca-certificates curl
sudo install -m 0755 -d /etc/apt/keyrings
sudo curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc
sudo chmod a+r /etc/apt/keyrings/docker.asc
# Add the repository to Apt sources:
sudo tee /etc/apt/sources.list.d/docker.sources <<EOF
Types: deb
URIs: https://download.docker.com/linux/ubuntu
Suites: $(. /etc/os-release && echo "${UBUNTU_CODENAME:-$VERSION_CODENAME}")
Components: stable
Architectures: $(dpkg --print-architecture)
Signed-By: /etc/apt/keyrings/docker.asc
EOF
sudo apt update && sudo apt install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin -y
sudo systemctl status docker
sudo systemctl start docker
sudo docker run hello-world
sudo apt-get install -y uidmap
/usr/bin/dockerd-rootless-setuptool.sh install
systemctl --user enable docker
sudo loginctl enable-linger $(whoami)

# Fish shell
sudo add-apt-repository ppa:fish-shell/release-4 -y
sudo apt install fish -y
command -v fish | sudo tee -a /etc/shells
chsh -s "$(command -v fish)"
# Finishing setup for Zoxide
fish -c "fish_add_path ~/.local/bin"

# Finishing up
sudo apt update -y
sudo apt upgrade -y
sudo apt autoremove
