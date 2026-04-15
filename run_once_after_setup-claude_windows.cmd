@echo off
powershell.exe -NoProfile -NonInteractive -ExecutionPolicy Bypass -File "%USERPROFILE%\dotfiles\setup-claude.ps1"
exit /b %ERRORLEVEL%
