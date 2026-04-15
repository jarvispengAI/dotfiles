#!/usr/bin/env bash
# Clone Claude Code plugin marketplace repos to ~/.claude/plugins/marketplaces/
# Runs once on first `chezmoi apply`; re-runs if this file changes.

set -euo pipefail

MARKETPLACES_DIR="$HOME/.claude/plugins/marketplaces"
mkdir -p "$MARKETPLACES_DIR"

clone_or_pull() {
    local repo="$1"   # e.g. affaan-m/everything-claude-code
    local dest="$2"   # e.g. everything-claude-code
    local target="$MARKETPLACES_DIR/$dest"

    if [[ -d "$target/.git" ]]; then
        echo "==> Updating $dest..."
        git -C "$target" pull --ff-only --quiet
    else
        echo "==> Cloning $repo → $dest..."
        git clone --depth=1 "https://github.com/$repo.git" "$target"
    fi
}

clone_or_pull "affaan-m/everything-claude-code"      "everything-claude-code"
clone_or_pull "thedotmack/claude-mem"                "thedotmack"
clone_or_pull "obra/superpowers-marketplace"         "superpowers-marketplace"
clone_or_pull "anthropics/knowledge-work-plugins"    "knowledge-work-plugins"
clone_or_pull "forrestchang/andrej-karpathy-skills"  "karpathy-skills"

echo " OK Claude plugin marketplaces ready at $MARKETPLACES_DIR"
