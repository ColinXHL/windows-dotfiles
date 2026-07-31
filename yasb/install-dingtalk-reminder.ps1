$ErrorActionPreference = "Stop"

function ConvertFrom-CodePoints([int[]]$codePoints) {
    return -join ($codePoints | ForEach-Object { [char]$_ })
}

$dingTalkExe = "C:\Program Files (x86)\DingDing\main\current\DingTalk.exe"
$autoHotkeyExe = Join-Path $env:ProgramFiles "AutoHotkey\v2\AutoHotkey64.exe"
$runtimeDirectory = Join-Path $env:LOCALAPPDATA "YASB"
$monitorRuntime = Join-Path $runtimeDirectory "DingTalkBadgeMonitor.exe"
$toastExe = Join-Path $runtimeDirectory "DingTalkToast.exe"
$iconPng = Join-Path $runtimeDirectory "dingtalk-reminder.png"
$iconIco = Join-Path $runtimeDirectory "dingtalk-reminder.ico"
$toastSource = Join-Path $PSScriptRoot "dingtalk-toast.cs"
$monitorScript = Join-Path $PSScriptRoot "dingtalk-badge-monitor.ahk"
$csc = Join-Path $env:WINDIR "Microsoft.NET\Framework64\v4.0.30319\csc.exe"
$winMetadata = Join-Path $env:WINDIR "System32\WinMetadata"
$systemRuntime = Join-Path $env:WINDIR "Microsoft.NET\Framework64\v4.0.30319\System.Runtime.dll"
$windowsRuntime = Join-Path $env:WINDIR "Microsoft.NET\Framework64\v4.0.30319\System.Runtime.WindowsRuntime.dll"

foreach ($path in @($dingTalkExe, $autoHotkeyExe, $toastSource, $monitorScript, $csc, $systemRuntime, $windowsRuntime)) {
    if (-not (Test-Path -LiteralPath $path)) {
        throw "Required file not found: $path"
    }
}

if (-not (Test-Path -LiteralPath $runtimeDirectory)) {
    New-Item -ItemType Directory -Path $runtimeDirectory | Out-Null
}

Add-Type -AssemblyName System.Drawing
$icon = [Drawing.Icon]::ExtractAssociatedIcon($dingTalkExe)
$bitmap = $icon.ToBitmap()
$bitmap.Save($iconPng, [Drawing.Imaging.ImageFormat]::Png)
$iconStream = [IO.File]::Create($iconIco)
$icon.Save($iconStream)
$iconStream.Dispose()
$bitmap.Dispose()
$icon.Dispose()

$compilerArguments = @(
    "/nologo",
    "/target:winexe",
    "/optimize+",
    "/out:$toastExe",
    "/win32icon:$iconIco",
    "/reference:$(Join-Path $winMetadata 'Windows.Foundation.winmd')",
    "/reference:$(Join-Path $winMetadata 'Windows.Data.winmd')",
    "/reference:$(Join-Path $winMetadata 'Windows.UI.winmd')",
    "/reference:$systemRuntime",
    "/reference:$windowsRuntime",
    $toastSource
)
& $csc @compilerArguments
if ($LASTEXITCODE -ne 0) {
    throw "Failed to compile DingTalkToast.exe."
}

$appIdKey = "HKCU:\Software\Classes\AppUserModelId\ColinXHL.DingTalkReminder"
if (-not (Test-Path -LiteralPath $appIdKey)) {
    New-Item -Path $appIdKey -Force | Out-Null
}
New-ItemProperty -LiteralPath $appIdKey -Name "DisplayName" -Value (ConvertFrom-CodePoints @(0x9489, 0x9489)) -PropertyType String -Force | Out-Null
New-ItemProperty -LiteralPath $appIdKey -Name "IconUri" -Value $iconPng -PropertyType String -Force | Out-Null
New-ItemProperty -LiteralPath $appIdKey -Name "IconBackgroundColor" -Value "#0078D4" -PropertyType String -Force | Out-Null
New-ItemProperty -LiteralPath $appIdKey -Name "ShowInSettings" -Value 1 -PropertyType DWord -Force | Out-Null

$protocolKey = "HKCU:\Software\Classes\dingtalk-reminder"
$protocolIconKey = Join-Path $protocolKey "DefaultIcon"
$protocolCommandKey = Join-Path $protocolKey "shell\open\command"
New-Item -Path $protocolIconKey -Force | Out-Null
New-Item -Path $protocolCommandKey -Force | Out-Null
Set-Item -LiteralPath $protocolKey -Value "URL:DingTalk Reminder"
New-ItemProperty -LiteralPath $protocolKey -Name "URL Protocol" -Value "" -PropertyType String -Force | Out-Null
Set-Item -LiteralPath $protocolIconKey -Value ('"' + $dingTalkExe + '"')
Set-Item -LiteralPath $protocolCommandKey -Value ('"' + $toastExe + '" open "%1"')

$monitorProcesses = @(Get-Process -Name "DingTalkBadgeMonitor" -ErrorAction SilentlyContinue)
if ($monitorProcesses.Count -gt 0) {
    $monitorProcesses | Stop-Process -Force
    $monitorProcesses | Wait-Process -Timeout 5 -ErrorAction SilentlyContinue
}
Copy-Item -LiteralPath $autoHotkeyExe -Destination $monitorRuntime -Force

$startupDirectory = [Environment]::GetFolderPath("Startup")
$shortcutPath = Join-Path $startupDirectory "DingTalk Badge Monitor.lnk"
$shell = New-Object -ComObject WScript.Shell
$shortcut = $shell.CreateShortcut($shortcutPath)
$shortcut.TargetPath = $monitorRuntime
$shortcut.Arguments = '"' + $monitorScript + '"'
$shortcut.WorkingDirectory = $PSScriptRoot
$shortcut.IconLocation = $dingTalkExe + ",0"
$shortcut.Save()

Start-Process -FilePath $monitorRuntime -ArgumentList ('"' + $monitorScript + '"') -WorkingDirectory $PSScriptRoot
