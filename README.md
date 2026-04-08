# dotfiles — Jarvis Peng

Managed by [chezmoi](https://chezmoi.io) + [1Password CLI](https://developer.1password.com/docs/cli/).

## 第一次設定新電腦（3步驟）

### Windows

```powershell
# 1. 以系統管理員身份開啟 PowerShell，執行：
Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser

# 2. 執行 bootstrap（自動安裝所有工具並套用 dotfiles）
irm https://raw.githubusercontent.com/jarvispengAI/dotfiles/main/scripts/bootstrap-windows.ps1 | iex
```

### Mac

```bash
# 執行 bootstrap（自動安裝 Homebrew、所有工具並套用 dotfiles）
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/jarvispengAI/dotfiles/main/scripts/bootstrap-mac.sh)"
```

---

## 日常使用 — 修改設定

```bash
# 查看哪些檔案會被更新
chezmoi diff

# 套用最新設定到本機
chezmoi apply

# 修改某個設定檔（會自動開啟 source 檔）
chezmoi edit ~/.gitconfig

# 把修改推到 GitHub
cd $(chezmoi source-path) && git add -A && git commit -m "update" && git push
```

---

## 新增 Secret 到 1Password

1. 在 1Password App 裡新增 item（選好 vault、item名稱、field名稱）
2. 編輯 `private_dot_env.tmpl`：

```bash
chezmoi edit ~/.env
```

加入這行並取消註解：
```
export MY_SECRET={{ onepasswordRead "op://VaultName/ItemName/FieldName" }}
```

3. 套用：

```bash
chezmoi apply
```

---

## 目錄結構

```
dotfiles/
├── .chezmoi.toml.tmpl                          # chezmoi 設定（name, email）
├── dot_gitconfig.tmpl                          # → ~/.gitconfig
├── dot_bash_profile.tmpl                       # → ~/.bash_profile（Git Bash / Linux）
├── dot_zshrc.tmpl                              # → ~/.zshrc（Mac）
├── dot_ssh/
│   └── config.tmpl                             # → ~/.ssh/config
├── dot_config/
│   └── powershell/
│       └── Microsoft.PowerShell_profile.ps1.tmpl  # → PowerShell profile
├── private_dot_env.tmpl                        # → ~/.env（secrets，由 1Password 填入）
├── .chezmoiignore                              # 跨平台忽略規則
└── scripts/
    ├── bootstrap-windows.ps1                   # Windows 新機器一鍵設定
    └── bootstrap-mac.sh                        # Mac 新機器一鍵設定
```

---

## VS Code Settings Sync

Settings Sync 是 VS Code 內建功能，**獨立於 chezmoi**：

1. VS Code → 左下角帳號圖示
2. **Turn on Settings Sync**
3. 登入 GitHub 帳號 (jarvispengAI)
4. 選擇要同步的項目（全選即可）

同步內容：Extensions、Settings、Keybindings、Snippets

---

## SSH Keys 策略

每台電腦各自產生一把 key，**都加進 GitHub**：

- Windows key: `~/.ssh/id_ed25519`（comment: `jarvispengAI-windows`）
- Mac key: `~/.ssh/id_ed25519`（comment: `jarvispengAI-mac`）

在 GitHub → Settings → SSH Keys 加入兩台電腦的 public key。
這樣不需要傳輸 private key，更安全。
