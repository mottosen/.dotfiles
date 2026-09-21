set -euo pipefail

# --- config ---
BIN_DIR="$HOME/.local/bin"
mkdir -p "$BIN_DIR"

# Detect architecture for GitHub release assets
case "$(uname -m)" in
    x86_64)  ARCH_ZELLIJ="x86_64";  ARCH_DEB="amd64" ;;
    aarch64) ARCH_ZELLIJ="aarch64"; ARCH_DEB="arm64" ;;
    *) echo "Unsupported arch: $(uname -m)"; exit 1 ;;
esac

# Ensure prerequisites
sudo apt-get update -y
sudo apt-get install -y curl git unzip tar kitty-terminfo stow

# --- fzf (official git install: bundles keybindings + completion) ---
if [ ! -d "$HOME/.fzf" ]; then
    git clone --depth 1 https://github.com/junegunn/fzf.git "$HOME/.fzf"
fi

"$HOME/.fzf/install" --bin   # builds binary into ~/.fzf/bin
ln -sf "$HOME/.fzf/bin/fzf" "$BIN_DIR/fzf"

# --- zellij (latest musl static binary) ---
curl -fsSL "https://github.com/zellij-org/zellij/releases/latest/download/zellij-${ARCH_ZELLIJ}-unknown-linux-musl.tar.gz" \
    | tar -xz -C "$BIN_DIR"
chmod +x "$BIN_DIR/zellij"

# --- zoxide (official installer -> ~/.local/bin) ---
curl -sSfL https://raw.githubusercontent.com/ajeetdsouza/zoxide/main/install.sh \
    | sh -s -- --bin-dir "$BIN_DIR"

# --- oh-my-posh (official installer) ---
curl -s https://ohmyposh.dev/install.sh | bash -s -- -d "$BIN_DIR"

# --- diff-so-fancy (single executable from latest release) ---
curl -fsSL "https://github.com/so-fancy/diff-so-fancy/releases/latest/download/diff-so-fancy" \
    -o "$BIN_DIR/diff-so-fancy"

chmod +x "$BIN_DIR/diff-so-fancy"

echo "Done. Installed into $BIN_DIR"
