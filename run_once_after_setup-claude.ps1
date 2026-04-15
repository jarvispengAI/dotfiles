# Clone Claude Code plugin marketplace repos to ~/.claude/plugins/marketplaces/
# Runs once on first `chezmoi apply`; re-runs if this file changes.

$ErrorActionPreference = "Stop"

$marketplacesDir = Join-Path $HOME ".claude\plugins\marketplaces"
if (-not (Test-Path $marketplacesDir)) {
    New-Item -ItemType Directory -Path $marketplacesDir | Out-Null
}

function Clone-OrPull {
    param([string]$Repo, [string]$Dest)
    $target = Join-Path $marketplacesDir $Dest
    if (Test-Path (Join-Path $target ".git")) {
        Write-Host "==> Updating $Dest..."
        git -C $target pull --ff-only --quiet
    } else {
        Write-Host "==> Cloning $Repo -> $Dest..."
        git clone --depth=1 "https://github.com/$Repo.git" $target
    }
}

Clone-OrPull "affaan-m/everything-claude-code"      "everything-claude-code"
Clone-OrPull "thedotmack/claude-mem"                "thedotmack"
Clone-OrPull "obra/superpowers-marketplace"         "superpowers-marketplace"
Clone-OrPull "anthropics/knowledge-work-plugins"    "knowledge-work-plugins"
Clone-OrPull "forrestchang/andrej-karpathy-skills"  "karpathy-skills"

Write-Host " OK Claude plugin marketplaces ready at $marketplacesDir" -ForegroundColor Green
