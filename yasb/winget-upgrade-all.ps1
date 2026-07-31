$Host.UI.RawUI.WindowTitle = "Winget Upgrade"

winget.exe upgrade --all --include-unknown --accept-source-agreements --accept-package-agreements --disable-interactivity

Write-Host ""
Write-Host "Winget upgrade finished. Right-click the YASB update icon to refresh." -ForegroundColor Green
