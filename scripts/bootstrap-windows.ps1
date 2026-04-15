# bootstrap-windows.ps1
# Run this ONCE on a fresh Windows machine (as Administrator recommended)
# Usage: irm https://raw.githubusercontent.com/jarvispengAI/dotfiles/main/scripts/bootstrap-windows.ps1 | iex
#   OR:  .\scripts\bootstrap-windows.ps1

param(
    [string]$DotfilesRepo = "https://github.com/jarvispengAI/dotfiles.git"
)

Set-StrictMode -Version Latest
$ErrorActionPreference = "Stop"

function Log { param($msg) Write-Host "==> $msg" -ForegroundColor Cyan }
function Ok  { param($msg) Write-Host " OK $msg" -ForegroundColor Green }

# ── 1. Install winget packages ───────────────────────────────────────────────
Log "Installing packages via winget..."

$packages = @(
    "twpayne.chezmoi",          # dotfiles manager
    "Bitwarden.Bitwarden",      # password manager
    "Bitwarden.CLI",            # Bitwarden CLI (bw)
    "Git.Git",                  # Git
    "Microsoft.VisualStudioCode",
    "GitHub.GitHubCLI",         # gh CLI
    "OpenJS.NodeJS.LTS",        # Node.js
    "Python.Python.3.12"        # Python
    # "JanDeDobbeleer.OhMyPosh" # Optional: cross-platform prompt
)

foreach ($pkg in $packages) {
    Log "Installing $pkg..."
    winget install --id $pkg -e --accept-source-agreements --accept-package-agreements
    Ok "$pkg"
}

# ── 2. Generate SSH key ───────────────────────────────────────────────────────
Log "Generating SSH key..."
$sshDir  = "$HOME\.ssh"
$keyPath = "$sshDir\id_ed25519"

if (-not (Test-Path $keyPath)) {
    if (-not (Test-Path $sshDir)) { New-Item -ItemType Directory -Path $sshDir | Out-Null }
    ssh-keygen -t ed25519 -C "jarvispengAI-windows" -f $keyPath -N '""'
    Ok "SSH key created at $keyPath"
} else {
    Ok "SSH key already exists, skipping"
}

Write-Host ""
Write-Host "===  Add this public key to GitHub:  ===" -ForegroundColor Yellow
Write-Host "https://github.com/settings/ssh/new" -ForegroundColor Yellow
Write-Host ""
Get-Content "$keyPath.pub"
Write-Host ""
Read-Host "Press Enter after adding the SSH key to GitHub..."

# ── 3. Sign in to Bitwarden CLI ──────────────────────────────────────────────
Log "Sign in to Bitwarden CLI..."
bw login
$env:BW_SESSION = bw unlock --raw
Ok "Bitwarden CLI authenticated (BW_SESSION set)"

# ── 4. Set up chezmoi with dotfiles repo ─────────────────────────────────────
Log "Initializing chezmoi from $DotfilesRepo..."
chezmoi init --apply --source "$env:USERPROFILE\dotfiles" $DotfilesRepo
Ok "chezmoi applied"

# ── 5. VS Code extensions ────────────────────────────────────────────────────
Log "Installing VS Code extensions..."
$extensions = @(
    "ms-python.python",
    "dbaeumer.vscode-eslint",
    "esbenp.prettier-vscode",
    "eamodio.gitlens",
    "ms-vscode-remote.remote-ssh"
)
foreach ($ext in $extensions) {
    code --install-extension $ext
}
Ok "VS Code extensions installed"

Write-Host ""
Write-Host "=== Bootstrap complete! ===" -ForegroundColor Green
Write-Host "Next: Open VS Code and enable Settings Sync (Accounts icon → Turn on Settings Sync)"
Write-Host ""
