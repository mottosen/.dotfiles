#!/usr/bin/env bash
set -euo pipefail

die() { echo "ERROR: $*" >&2; exit 1; }
trap 'echo "A command failed. See logs above."' ERR

# Pick dnf5 when available (Fedora 41+), else dnf
dnf_cmd() { command -v dnf5 >/dev/null 2>&1 && echo dnf5 || echo dnf; }

enable_all_repos() {
  local DNF="$(dnf_cmd)"
  echo "[*] Installing DNF plugin package and enabling third‑party repos..."

  # dnf plugin package (needed for config-manager & copr)
  if [ "$DNF" = "dnf5" ]; then
    sudo "$DNF" install -y dnf5-plugins   # provides config-manager, copr, etc.
  else
    sudo "$DNF" install -y dnf-plugins-core
  fi

  # Microsoft: .NET & VS Code
  sudo rpm --import https://packages.microsoft.com/keys/microsoft.asc
  sudo "$DNF" install -y https://packages.microsoft.com/config/fedora/42/packages-microsoft-prod.rpm
  sudo tee /etc/yum.repos.d/vscode.repo >/dev/null <<'EOF'
[code]
name=Visual Studio Code
baseurl=https://packages.microsoft.com/yumrepos/vscode
enabled=1
gpgcheck=1
gpgkey=https://packages.microsoft.com/keys/microsoft.asc
EOF

  # Docker CE repo
  if [ "$DNF" = "dnf5" ]; then
    sudo "$DNF" config-manager addrepo --from-repofile=https://download.docker.com/linux/fedora/docker-ce.repo
  else
    sudo "$DNF" config-manager --add-repo https://download.docker.com/linux/fedora/docker-ce.repo
  fi

  # COPRs for Hyprland extras & Bibata cursors
  sudo "$DNF" copr enable -y solopasha/hyprland
  sudo "$DNF" copr enable -y carlwgeorge/bibata-cursor-theme
}

install_all_dnf_packages() {
  local DNF="$(dnf_cmd)"
  echo "[*] Installing packages via $DNF in one transaction..."
  sudo "$DNF" install -y \
    # Dev & CLI
    stow neovim code git fzf ripgrep ranger btop diff-so-fancy \ #net-sdk-9.0
    libnotify brightnessctl fastfetch zsh zoxide oh-my-posh pipx cargo \
    pcmanfm \
    # Hyprland stack (Fedora + COPR)
    hyprland hyprcursor waybar wofi \
    xdg-desktop-portal-hyprland hyprland-plugins hyprland-contrib \
    hypridle hyprlock hyprpaper hyprshot waypaper matugen \
    # Docker CE + plugins
    docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
}

install_flatpaks() {
  echo "[*] Installing Flatpaks (user scope)..."
  flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo
  flatpak install -y flathub \
    org.zotero.Zotero \
    org.wezfurlong.wezterm \
    app.eduroam.geteduroam
}

enable_docker_service() {
  echo "[*] Enabling Docker service and group..."
  sudo systemctl enable --now docker
  sudo usermod -aG docker "$USER" || true
}

install_devbox() {
  echo "[*] Installing Devbox..."
  curl -fsSL https://get.jetify.com/devbox | bash
}

install_nerd_fonts() {
  echo "[*] Installing Nerd Fonts (JetBrainsMono & FiraCode) to ~/.local/share/fonts/NerdFonts ..."
  local FDIR="$HOME/.local/share/fonts/NerdFonts"
  mkdir -p "$FDIR"
  for font in JetBrainsMono FiraCode; do
    curl -fL "https://github.com/ryanoasis/nerd-fonts/releases/latest/download/${font}.zip" -o "/tmp/${font}.zip"
    unzip -o "/tmp/${font}.zip" -d "$FDIR/${font}"
    rm -f "/tmp/${font}.zip"
  done
  fc-cache -f "$HOME/.local/share/fonts"
}

apply_dotfiles() {
  echo "[*] Applying dotfiles from ~/.dotfiles with GNU Stow..."
  local DOTDIR="$HOME/.dotfiles"
  [ -d "$DOTDIR" ] || { echo "  - Skipping: $DOTDIR not found."; return 0; }
  cd "$DOTDIR"
  stow --adopt .
}

install_pywalfox() {
  echo "[*] Installing pywalfox via pipx..."
  pipx ensurepath
  pipx install pywalfox
  pywalfox install || true
}

# install_pomodoro() {
#   echo "[*] Installing pomodoro-cli (Waybar-friendly)..."
#   cargo install --locked pomodoro-cli
# }

set_zsh_default() {
  echo "[*] Setting Zsh as default shell..."
  chsh -s "$(command -v zsh)" "$USER"
}

install_lazygit() {
  # Separate due to COPR volatility; includes fallback to Go build
  local DNF="$(dnf_cmd)"
  echo "[*] Installing lazygit (COPR with fallback)..."
  if sudo "$DNF" copr enable -y dejan/lazygit && sudo "$DNF" install -y lazygit; then
    echo "  - Installed lazygit from COPR dejan/lazygit."
  elif sudo "$DNF" copr enable -y atim/lazygit && sudo "$DNF" install -y lazygit; then
    echo "  - Installed lazygit from COPR atim/lazygit."
  else
    echo "  - Falling back to Go build for lazygit..."
    sudo "$DNF" install -y golang
    GOBIN="$HOME/.local/bin" go install github.com/jesseduffield/lazygit@latest
    echo "  - Installed to $HOME/.local/bin. Ensure it's on your PATH."
  fi
}

main() {
  sudo "$(dnf_cmd)" upgrade -y
  enable_all_repos
  install_all_dnf_packages
  install_flatpaks
  enable_docker_service
  install_devbox
  install_nerd_fonts
  apply_dotfiles
  install_pywalfox
  install_pomodoro
  install_lazygit
  set_zsh_default
  echo "✓ Setup complete. Log out/in for Docker group and default shell to take effect."
}
main "$@"

