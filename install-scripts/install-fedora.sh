#!/usr/bin/env bash
set -e  # Exit immediately if a command fails
set -o pipefail

#----------------------------------------
# Functions
#----------------------------------------
install_dnf_packages() {
    echo "Installing DNF packages..."
    sudo dnf install -y "${DNF_PACKAGES[@]}"
}

install_flatpak_packages() {
    echo "Installing Flatpak packages..."
    sudo flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo
    for pkg in "${FLATPAK_PACKAGES[@]}"; do
        flatpak install -y flathub "$pkg"
    done
}

setup_docker() {
    echo "Setting up Docker..."
    sudo dnf remove -y docker docker-client docker-client-latest docker-common docker-latest docker-latest-logrotate docker-logrotate docker-selinux docker-engine-selinux docker-engine || true
    sudo dnf -y install dnf-plugins-core
    sudo dnf-3 config-manager --add-repo https://download.docker.com/linux/fedora/docker-ce.repo
    sudo dnf-3 install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
    sudo systemctl enable --now docker
    sudo usermod -aG docker "$USER"
}

setup_microsoft_repo() {
    echo "Setting up Microsoft repository..."
    sudo rpm --import https://packages.microsoft.com/keys/microsoft.asc
    sudo dnf install -y https://packages.microsoft.com/config/fedora/42/packages-microsoft-prod.rpm
    sudo sh -c 'echo -e "[code]\nname=Visual Studio Code\nbaseurl=https://packages.microsoft.com/yumrepos/vscode\nenabled=1\ngpgcheck=1\ngpgkey=https://packages.microsoft.com/keys/microsoft.asc" > /etc/yum.repos.d/vscode.repo'
    sudo dnf check-update
}

setup_devbox() {
    echo "Installing Devbox..."
    curl -fsSL https://get.jetify.com/devbox | bash
}

set_zsh_default() {
    echo "Setting Zsh as default shell..."
    chsh -s "$(which zsh)"
}

#----------------------------------------
# Packages
#----------------------------------------
DNF_PACKAGES=(
    stow
    neovim
    libudev-devel
    code
    dotnet-sdk-9.0
    fzf
    ripgrep
    ranger
    btop
    diff-so-fancy
    libnotify
    libinput
    brightnessctl
    fastfetch
    zsh
    oh-my-posh
    zoxide
)

FLATPAK_PACKAGES=(
    org.zotero.Zotero
    org.wezfurlong.wezterm
    # Add more Flatpak apps here, e.g. geteduroam, bibata-cursors, lazygit, uair
)

#----------------------------------------
# Run Setup
#----------------------------------------
setup_docker
setup_microsoft_repo
install_dnf_packages
install_flatpak_packages
setup_devbox
set_zsh_default

echo "Setup complete! Please log out and log back in for Docker and Zsh changes to take effect."

