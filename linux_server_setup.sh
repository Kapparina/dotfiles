#!/usr/bin/env bash
set -e
sudo -v

export NEEDRESTART_SUSPEND=1

# Time zone correction
echo Configuring time zone...
sudo timedatectl set-timezone Australia/Sydney
timedatectl

# Symlink for .config
mkdir "$HOME/.config"
source="$HOME/dotfiles/.config"
destination="$HOME/.config"
shopt -s dotglob
for item in "$source"/*; do
    ln -s "$item" "$destination/"
done

# Package Installation Prerequisites
echo Configuring prerequisite packages...
sudo apt install ca-certificates curl -y
sudo apt remove $(dpkg --get-selections docker.io docker-compose docker-compose-v2 docker-doc docker-buildx podman-docker containerd runc | cut -f1)
(type -p wget >/dev/null || (sudo apt update && sudo apt install wget -y))

# Setting up repositories
echo Setting up Repositories...

echo Yazi...
curl -fsSL https://yazi-rs.github.io/builds/yazi-keyring.gpg | sudo tee /usr/share/keyrings/yazi-keyring.gpg >/dev/null
echo 'deb [signed-by=/usr/share/keyrings/yazi-keyring.gpg] https://yazi-rs.github.io/builds/ stable main' | sudo tee /etc/apt/sources.list.d/yazi.list >/dev/null

echo Fish...
sudo add-apt-repository ppa:fish-shell/release-4 -y

echo Docker...
# Add Docker's official GPG key:
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

echo GitHub CLI...
sudo mkdir -p -m 755 /etc/apt/keyrings \
&& out=$(mktemp) && wget -nv -O$out https://cli.github.com/packages/githubcli-archive-keyring.gpg \
&& cat $out | sudo tee /etc/apt/keyrings/githubcli-archive-keyring.gpg > /dev/null \
&& sudo chmod go+r /etc/apt/keyrings/githubcli-archive-keyring.gpg \
&& sudo mkdir -p -m 755 /etc/apt/sources.list.d \
&& echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/githubcli-archive-keyring.gpg] https://cli.github.com/packages stable main" | sudo tee /etc/apt/sources.list.d/github-cli.list > /dev/null

echo Charm...
sudo mkdir -p /etc/apt/keyrings
curl -fsSL https://repo.charm.sh/apt/gpg.key | sudo gpg --dearmor -o /etc/apt/keyrings/charm.gpg
echo "deb [signed-by=/etc/apt/keyrings/charm.gpg] https://repo.charm.sh/apt/ * *" | sudo tee /etc/apt/sources.list.d/charm.list

packages=(
    eza # ls replacement
    apparmor-utils
    bluez # Bluetooth
    yazi
    # Yazi optionals
    fzf
    ripgrep
    jq
    fd-find
    ffmpeg
    bat # Terminal reader
    starship # Prompt
    # Docker
    docker-ce
    docker-ce-cli
    containerd.io
    docker-buildx-plugin
    docker-compose-plugin
    # Docker optionals
    uidmap
    cifs-utils
    acl
    fish # Shell
    gh # GitHub CLI
    gum # For pretty/functional scripts
)
sudo apt update && sudo apt install -y "${packages[@]}"

# Bluetooth
echo Configuring Bluetooth...
sudo systemctl enable --now bluetooth

# Neovim
echo Installing Neovim...
sudo snap install nvim --classic

# Go
echo Installing Go...
sudo snap install go --classic

# Zoxide
echo Installing Zoxide...
curl -sSfL https://raw.githubusercontent.com/ajeetdsouza/zoxide/main/install.sh | sh

# GitHub CLI
echo Configuring GH CLI...
if ! gh auth status &>/dev/null; then
    GH_BROWSER=/bin/true gh auth login --git-protocol ssh
fi

# Dotfiles remote correction
echo Correcting dotfiles remote configuration...
pushd ~/dotfiles
git remote set-url origin git@github.com:Kapparina/dotfiles.git
popd

# Docker
echo Configuring Docker...
sudo systemctl status docker
sudo systemctl start docker
sudo docker run hello-world
/usr/bin/dockerd-rootless-setuptool.sh install
systemctl --user enable docker
sudo loginctl enable-linger $(whoami)

# Fish shell
echo Configuring Fish as default login shell...
command -v fish | sudo tee -a /etc/shells
chsh -s "$(command -v fish)"
# Finishing setup for Zoxide
echo Configuring Fish for Zoxide compatibility...
fish -c "fish_add_path ~/.local/bin"

# Finishing up
echo Cleaning up...
sudo apt update -y
sudo apt upgrade -y
sudo apt autoremove
