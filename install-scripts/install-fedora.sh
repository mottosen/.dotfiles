#!/usr/bin/env bash
set -euo pipefail

die() { echo "ERROR: $*" >&2; exit 1; }
trap 'echo "A command failed. See logs above."' ERR

# Pick dnf5 when available (Fedora 41+), else dnf
dnf_cmd() { command -v dnf5 >/dev/null 2>&1 && echo dnf5 || echo dnf; }

enable_all_repos() {
  local DNF="$(dnf_cmd)"
  echo "[*] Installing DNF plugin package and enabling third-party repos..."

  # dnf plugin package (needed for config-manager & copr)
  if [ "$DNF" = "dnf5" ]; then
    sudo "$DNF" install -y dnf5-plugins
  else
    sudo "$DNF" install -y dnf-plugins-core
  fi

  # --- Microsoft repo: import key + install repo FIRST, then refresh ---
  sudo rpm --import https://packages.microsoft.com/keys/microsoft.asc || true
  if ! rpm -q packages-microsoft-prod >/dev/null 2>&1; then
    sudo "$DNF" install -y https://packages.microsoft.com/config/fedora/42/packages-microsoft-prod.rpm
  fi
  # ensure VS Code repo file exists (idempotent)
  sudo tee /etc/yum.repos.d/vscode.repo >/dev/null <<'EOF'
[code]
name=Visual Studio Code
baseurl=https://packages.microsoft.com/yumrepos/vscode
enabled=1
gpgcheck=1
gpgkey=https://packages.microsoft.com/keys/microsoft.asc
EOF

  # Clean & refresh AFTER keys/repos are present to avoid transient GPG errors
  sudo "$DNF" clean all
  sudo "$DNF" makecache -y || true

  # --- Docker CE repo: add only if missing (dnf5 complains otherwise) ---
  if [ ! -f /etc/yum.repos.d/docker-ce.repo ]; then
    if [ "$DNF" = "dnf5" ]; then
      sudo "$DNF" config-manager addrepo --from-repofile=https://download.docker.com/linux/fedora/docker-ce.repo
    else
      sudo "$DNF" config-manager --add-repo https://download.docker.com/linux/fedora/docker-ce.repo
    fi
  else
    echo "  - Docker repo already exists; skipping add."
    # If you ever need to refresh it instead, uncomment:
    # [ "$DNF" = "dnf5" ] && sudo "$DNF" config-manager addrepo --overwrite --from-repofile=https://download.docker.com/linux/fedora/docker-ce.repo
  fi

  # --- COPRs (idempotent; re-enabling is fine) ---
  sudo "$DNF" copr enable -y solopasha/hyprland
  sudo "$DNF" copr enable -y varlad/zellij
}

install_all_dnf_packages() {
  local DNF="$(dnf_cmd)"
  echo "[*] Installing packages via $DNF in one transaction..."

  DNF_PACKAGES=(
    # Dev & CLI
    stow neovim code git fzf ripgrep ranger btop diff-so-fancy dotnet-sdk-9.0
    libnotify brightnessctl fastfetch zsh zoxide oh-my-posh pipx cargo libusb
    pcmanfm kitty zellij python3-pip golang
    @development-tools gcc gcc-c++ make perl tar xz

    # Hyprland stack (Fedora + COPR)
    hyprland hyprcursor waybar wofi
    xdg-desktop-portal-hyprland hyprland-plugins hyprland-contrib
    hypridle hyprlock hyprpaper hyprshot waypaper matugen mako

    # Docker CE + plugins
    docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
  )

  sudo "$DNF" install -y "${DNF_PACKAGES[@]}"
}

install_flatpaks() {
  echo "[*] Installing Flatpaks (user scope)..."
  flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo
  flatpak install -y flathub \
    org.zotero.Zotero \
    app.eduroam.geteduroam \
    app.zen_browser.zen
}

install_devbox() {
  echo "[*] Installing Devbox..."
  curl -fsSL https://get.jetify.com/devbox | bash
}

install_nerd_fonts() {
  echo "[*] Installing Nerd Fonts to ~/.local/share/fonts/NerdFonts ..."
  local FDIR="$HOME/.local/share/fonts/NerdFonts"
  mkdir -p "$FDIR"
  for font in JetBrainsMono FiraCode; do
    curl -fL "https://github.com/ryanoasis/nerd-fonts/releases/latest/download/${font}.zip" -o "/tmp/${font}.zip"
    unzip -o "/tmp/${font}.zip" -d "$FDIR/${font}"
    rm -f "/tmp/${font}.zip"
  done
  fc-cache -f "$HOME/.local/share/fonts"
}

install_pywalfox() {
  echo "[*] Installing pywalfox via pipx..."
  pipx ensurepath
  pipx install pywalfox
  pywalfox install || true
}

install_uair() {
  echo "[*] Installing uair (CLI Pomodoro) via cargo ..."
  cargo install uair
}

install_lazygit() {
  # COPR with fallback to Go build
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

install_haskell_toolchain() {
  echo "[*] Installing Haskell toolchain via ghcup (non-interactive)..."
  export BOOTSTRAP_HASKELL_NONINTERACTIVE=1
  export BOOTSTRAP_HASKELL_MINIMAL=1   # set to 0 if you also want stack, etc.
  curl --proto '=https' --tlsv1.2 -sSf https://get-ghcup.haskell.org | bash

  # Use ghcup to install recommended versions
  "$HOME/.ghcup/bin/ghcup" install ghc recommended
  "$HOME/.ghcup/bin/ghcup" set ghc recommended
  "$HOME/.ghcup/bin/ghcup" install cabal recommended
  "$HOME/.ghcup/bin/ghcup" install hls recommended
}

enable_docker_service() {
  echo "[*] Enabling Docker service and group..."
  sudo systemctl enable --now docker
  sudo usermod -aG docker "$USER" || true
}

apply_dotfiles() {
  echo "[*] Applying dotfiles from ~/.dotfiles with GNU Stow..."
  local DOTDIR="$HOME/.dotfiles"
  [ -d "$DOTDIR" ] || { echo "  - Skipping: $DOTDIR not found."; return 0; }
  cd "$DOTDIR"
  stow --adopt .
}

set_zsh_default() {
  echo "[*] Setting Zsh as default shell..."
  chsh -s "$(command -v zsh)" "$USER"
}

config_zsa() {
  echo "[*] Configuring zsa udev rules..."
  sudo cp "$HOME/.dotfiles/udev-rules/zsa_voyager" "/etc/udev/rules.d/50-zsa.rules"
  sudo groupadd plugdev 2>/dev/null || true
  sudo usermod -aG plugdev "$USER"
}

config_bibata_cursors() {
  echo "[*] Configuring bibata cursors..."
  # download icon files
  cd "$HOME/Downloads"
  curl -L -o Bibata.tar.xz \
    https://github.com/ful1e5/Bibata_Cursor/releases/download/v2.0.7/Bibata.tar.xz

  # extract icon files
  mkdir "$HOME/.icons"
  tar -xf Bibata.tar.xz -C "$HOME/.icons"
}

main() {
  sudo "$(dnf_cmd)" upgrade -y
  enable_all_repos
  install_all_dnf_packages
  install_flatpaks
  install_devbox
  install_nerd_fonts
  install_pywalfox
  install_uair
  install_lazygit
  install_haskell_toolchain
  enable_docker_service
  apply_dotfiles
  set_zsh_default
  config_zsa
  config_bibata_cursors
  echo "✓ Setup complete. Log out/in for Docker group and default shell to take effect."
}
main "$@"

