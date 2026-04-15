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

# ── Install Claude Code plugins ───────────────────────────────────────────────
Write-Host "==> Installing Claude Code plugins..."

$plugins = @(
    "everything-claude-code@everything-claude-code",
    "claude-mem@thedotmack",
    "agent-sdk-dev@claude-plugins-official",
    "clangd-lsp@claude-plugins-official",
    "claude-code-setup@claude-plugins-official",
    "claude-md-management@claude-plugins-official",
    "code-review@claude-plugins-official",
    "code-simplifier@claude-plugins-official",
    "commit-commands@claude-plugins-official",
    "csharp-lsp@claude-plugins-official",
    "explanatory-output-style@claude-plugins-official",
    "feature-dev@claude-plugins-official",
    "frontend-design@claude-plugins-official",
    "gopls-lsp@claude-plugins-official",
    "hookify@claude-plugins-official",
    "jdtls-lsp@claude-plugins-official",
    "kotlin-lsp@claude-plugins-official",
    "learning-output-style@claude-plugins-official",
    "lua-lsp@claude-plugins-official",
    "math-olympiad@claude-plugins-official",
    "mcp-server-dev@claude-plugins-official",
    "php-lsp@claude-plugins-official",
    "playground@claude-plugins-official",
    "plugin-dev@claude-plugins-official",
    "pr-review-toolkit@claude-plugins-official",
    "pyright-lsp@claude-plugins-official",
    "ralph-loop@claude-plugins-official",
    "ruby-lsp@claude-plugins-official",
    "rust-analyzer-lsp@claude-plugins-official",
    "security-guidance@claude-plugins-official",
    "session-report@claude-plugins-official",
    "skill-creator@claude-plugins-official",
    "swift-lsp@claude-plugins-official",
    "typescript-lsp@claude-plugins-official",
    "productivity@knowledge-work-plugins",
    "enterprise-search@knowledge-work-plugins",
    "cowork-plugin-management@knowledge-work-plugins",
    "sales@knowledge-work-plugins",
    "finance@knowledge-work-plugins",
    "data@knowledge-work-plugins",
    "legal@knowledge-work-plugins",
    "marketing@knowledge-work-plugins",
    "customer-support@knowledge-work-plugins",
    "product-management@knowledge-work-plugins",
    "bio-research@knowledge-work-plugins",
    "slack-by-salesforce@knowledge-work-plugins",
    "apollo@knowledge-work-plugins",
    "common-room@knowledge-work-plugins",
    "engineering@knowledge-work-plugins",
    "human-resources@knowledge-work-plugins",
    "design@knowledge-work-plugins",
    "operations@knowledge-work-plugins",
    "brand-voice@knowledge-work-plugins",
    "zoom-plugin@knowledge-work-plugins",
    "pdf-viewer@knowledge-work-plugins",
    "andrej-karpathy-skills@karpathy-skills"
)

foreach ($plugin in $plugins) {
    Write-Host "==> Installing $plugin..."
    claude plugins install $plugin --yes
}

Write-Host " OK Claude plugins installed" -ForegroundColor Green
