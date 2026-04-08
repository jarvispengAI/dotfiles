#!/usr/bin/env bash
# bootstrap-mac.sh
# Run this ONCE on a fresh Mac.
# Usage: /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/jarvispengAI/dotfiles/main/scripts/bootstrap-mac.sh)"
#   OR:  bash scripts/bootstrap-mac.sh

set -euo pipefail

DOTFILES_REPO="https://github.com/jarvispengAI/dotfiles.git"

log() { echo "==> $*" ; }
ok()  { echo " OK $*" ; }

# ── 1. Homebrew ───────────────────────────────────────────────────────────────
log "Installing Homebrew..."
if ! command -v brew &>/dev/null; then
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
fi
eval "$(/opt/homebrew/bin/brew shellenv)"
ok "Homebrew ready"

# ── 2. Install packages via Brewfile ─────────────────────────────────────────
log "Installing packages via Homebrew..."
brew install \
    chezmoi \
    gh \
    git \
    node \
    python@3.12 \
    1password-cli   # op CLI

install_cask() {
    local name="$1" app="$2"
    if [[ -d "/Applications/$app" ]] || brew list --cask "$name" &>/dev/null; then
        echo " OK $name already installed, skipping"
    else
        brew install --cask "$name"
    fi
}
install_cask visual-studio-code "Visual Studio Code.app"
install_cask 1password "1Password.app"

ok "Packages installed"

# ── 3. Generate SSH key ───────────────────────────────────────────────────────
log "Setting up SSH key..."
KEY="$HOME/.ssh/id_ed25519"
if [[ ! -f "$KEY" ]]; then
    mkdir -p "$HOME/.ssh"
    ssh-keygen -t ed25519 -C "jarvispengAI-mac" -f "$KEY" -N ""
    ok "SSH key created at $KEY"
else
    ok "SSH key already exists, skipping"
fi

echo ""
echo "===  Add this public key to GitHub:  ==="
echo "https://github.com/settings/ssh/new"
echo ""
cat "$KEY.pub"
echo ""
read -rp "Press Enter after adding the SSH key to GitHub..."

# ── 4. Sign in to 1Password CLI ──────────────────────────────────────────────
log "Sign in to 1Password CLI..."
op account add
eval $(op signin)
ok "1Password CLI authenticated"

# ── 5. chezmoi init ───────────────────────────────────────────────────────────
log "Initializing chezmoi from $DOTFILES_REPO..."
chezmoi init --apply "$DOTFILES_REPO"
ok "chezmoi applied"

# ── 6. VS Code extensions ────────────────────────────────────────────────────
log "Installing VS Code extensions..."
extensions=(
    "ms-python.python"
    "dbaeumer.vscode-eslint"
    "esbenp.prettier-vscode"
    "eamodio.gitlens"
    "ms-vscode-remote.remote-ssh"
)
for ext in "${extensions[@]}"; do
    code --install-extension "$ext"
done
ok "VS Code extensions installed"

echo ""
echo "=== Bootstrap complete! ==="
echo "Next: Open VS Code and enable Settings Sync (Accounts icon → Turn on Settings Sync)"
echo ""
