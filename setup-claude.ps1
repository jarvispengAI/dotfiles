# Register Claude Code plugin marketplaces and install plugins.
# Runs once on first `chezmoi apply`; re-runs if this file changes.

$ErrorActionPreference = "Stop"

# ── Register marketplaces ─────────────────────────────────────────────────────
Write-Host "==> Registering Claude Code plugin marketplaces..."

$marketplaces = @(
    @{ Repo = "affaan-m/everything-claude-code";    Name = "everything-claude-code" },
    @{ Repo = "thedotmack/claude-mem";              Name = "thedotmack" },
    @{ Repo = "obra/superpowers-marketplace";        Name = "superpowers-marketplace" },
    @{ Repo = "anthropics/knowledge-work-plugins";  Name = "knowledge-work-plugins" },
    @{ Repo = "forrestchang/andrej-karpathy-skills"; Name = "karpathy-skills" }
)

foreach ($m in $marketplaces) {
    $existing = claude plugins marketplace list 2>&1 | Select-String $m.Name
    if ($existing) {
        Write-Host "    Already registered: $($m.Name)"
    } else {
        Write-Host "==> Adding marketplace $($m.Name)..."
        claude plugins marketplace add $m.Repo 2>&1 | Out-Null
        Write-Host "    OK $($m.Name)" -ForegroundColor Green
    }
}

Write-Host " OK Claude plugin marketplaces ready" -ForegroundColor Green

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
    "pdf-viewer@knowledge-work-plugins"
)

$failed = @()
foreach ($plugin in $plugins) {
    Write-Host "==> Installing $plugin..."
    try {
        claude plugins install $plugin 2>&1 | Out-Null
        Write-Host "    OK $plugin" -ForegroundColor Green
    } catch {
        Write-Host "    WARN: Failed to install $plugin - $_" -ForegroundColor Yellow
        $failed += $plugin
    }
}

if ($failed.Count -gt 0) {
    Write-Host ""
    Write-Host "The following plugins failed to install:" -ForegroundColor Yellow
    $failed | ForEach-Object { Write-Host "  - $_" -ForegroundColor Yellow }
    Write-Host "Re-run: chezmoi apply  to retry" -ForegroundColor Yellow
} else {
    Write-Host " OK Claude plugins installed" -ForegroundColor Green
}
