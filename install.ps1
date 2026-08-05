#Requires -Version 7.0

param(
    [switch] $SkipNilesoft
)

Set-StrictMode -Version Latest
$ErrorActionPreference = "Stop"

$repoRoot = $PSScriptRoot
$stamp = Get-Date -Format "yyyyMMdd-HHmmss"

function Set-ConfigLink {
    param(
        [Parameter(Mandatory)]
        [string] $Path,

        [Parameter(Mandatory)]
        [string] $Target
    )

    if (-not (Test-Path -LiteralPath $Target)) {
        throw "Link target does not exist: $Target"
    }

    $parent = Split-Path -Parent $Path
    if (-not (Test-Path -LiteralPath $parent)) {
        New-Item -ItemType Directory -Path $parent -Force | Out-Null
    }

    $item = Get-Item -LiteralPath $Path -Force -ErrorAction SilentlyContinue
    if ($null -ne $item) {
        $currentTarget = @($item.Target) | Select-Object -First 1
        if (
            $item.LinkType -eq "SymbolicLink" -and
            $null -ne $currentTarget -and
            [IO.Path]::GetFullPath([string] $currentTarget) -ieq [IO.Path]::GetFullPath($Target)
        ) {
            Write-Host "Already linked: $Path"
            return
        }

        $backup = "$Path.pre-dotfiles-$stamp.bak"
        Move-Item -LiteralPath $Path -Destination $backup
        Write-Host "Backed up: $Path -> $backup"
    }

    try {
        New-Item -ItemType SymbolicLink -Path $Path -Target $Target | Out-Null
        Write-Host "Linked: $Path -> $Target"
    } catch {
        if ($null -ne $item -and (Test-Path -LiteralPath $backup) -and -not (Test-Path -LiteralPath $Path)) {
            Move-Item -LiteralPath $backup -Destination $Path
        }

        throw
    }
}

function Set-ConfigTree {
    param(
        [Parameter(Mandatory)]
        [string] $Source,

        [Parameter(Mandatory)]
        [string] $Destination
    )

    Get-ChildItem -LiteralPath $Source -Recurse -File | ForEach-Object {
        $relativePath = [IO.Path]::GetRelativePath($Source, $_.FullName)
        Set-ConfigLink `
            -Path (Join-Path $Destination $relativePath) `
            -Target $_.FullName
    }
}

function Remove-StaleTreeLinks {
    param(
        [Parameter(Mandatory)]
        [string] $Source,

        [Parameter(Mandatory)]
        [string] $Destination
    )

    if (-not (Test-Path -LiteralPath $Destination)) {
        return
    }

    $sourceRoot = [IO.Path]::GetFullPath($Source).TrimEnd('\') + '\'
    Get-ChildItem -LiteralPath $Destination -Recurse -Force | ForEach-Object {
        if ($_.LinkType -ne "SymbolicLink") {
            return
        }

        $target = @($_.Target) | Select-Object -First 1
        if ($null -eq $target) {
            return
        }

        $targetPath = [IO.Path]::GetFullPath([string] $target)
        if ($targetPath.StartsWith($sourceRoot, [StringComparison]::OrdinalIgnoreCase) -and -not (Test-Path -LiteralPath $targetPath)) {
            Remove-Item -LiteralPath $_.FullName -Force
            Write-Host "Removed stale link: $($_.FullName) -> $targetPath"
        }
    }
}

function Move-LegacyGitMetadata {
    param(
        [Parameter(Mandatory)]
        [string] $ConfigPath
    )

    $gitPath = Join-Path $ConfigPath ".git"
    if (-not (Test-Path -LiteralPath $gitPath)) {
        return
    }

    $backup = "$ConfigPath.pre-dotfiles-$stamp.git"
    Move-Item -LiteralPath $gitPath -Destination $backup
    Write-Host "Archived legacy Git metadata: $gitPath -> $backup"
}

$weztermConfig = Join-Path $HOME ".config\wezterm"
$weztermSource = Join-Path $repoRoot "wezterm"

Set-ConfigLink `
    -Path (Join-Path $weztermConfig "wezterm.lua") `
    -Target (Join-Path $weztermSource "wezterm.lua")

Get-ChildItem -LiteralPath (Join-Path $weztermSource "modules") -Filter "*.lua" -File | ForEach-Object {
    Set-ConfigLink `
        -Path (Join-Path $weztermConfig "modules\$($_.Name)") `
        -Target $_.FullName
}

Set-ConfigTree `
    -Source (Join-Path $weztermSource "assets") `
    -Destination (Join-Path $weztermConfig "assets")

Set-ConfigLink `
    -Path (Join-Path $env:APPDATA "neovide\config.toml") `
    -Target (Join-Path $repoRoot "neovide\config.toml")

$nushellConfig = Join-Path $HOME ".config\nushell"
$nushellSource = Join-Path $repoRoot "nushell"

Set-ConfigLink `
    -Path (Join-Path $nushellConfig "config.nu") `
    -Target (Join-Path $nushellSource "config.nu")

Set-ConfigLink `
    -Path (Join-Path $nushellConfig "fastfetch.jsonc") `
    -Target (Join-Path $nushellSource "fastfetch.jsonc")

Get-ChildItem -LiteralPath (Join-Path $nushellSource "modules") -Filter "*.nu" -File | ForEach-Object {
    Set-ConfigLink `
        -Path (Join-Path $nushellConfig "modules\$($_.Name)") `
        -Target $_.FullName
}

Set-ConfigLink `
    -Path (Join-Path $HOME ".config\starship.toml") `
    -Target (Join-Path $repoRoot "nushell\starship.toml")

Set-ConfigLink `
    -Path (Join-Path $env:APPDATA "nushell\config.nu") `
    -Target (Join-Path $repoRoot "nushell\config.nu")

$powershellProfile = Join-Path `
    ([Environment]::GetFolderPath("MyDocuments")) `
    "PowerShell\Microsoft.PowerShell_profile.ps1"

Set-ConfigLink `
    -Path $powershellProfile `
    -Target (Join-Path $repoRoot "powershell\Microsoft.PowerShell_profile.ps1")

Set-ConfigTree `
    -Source (Join-Path $repoRoot "nvim") `
    -Destination (Join-Path $env:LOCALAPPDATA "nvim")

Remove-StaleTreeLinks `
    -Source (Join-Path $repoRoot "nvim") `
    -Destination (Join-Path $env:LOCALAPPDATA "nvim")

$gitFile = Join-Path $env:ProgramFiles "Git\usr\bin\file.exe"
if (Test-Path -LiteralPath $gitFile) {
    $env:YAZI_FILE_ONE = $gitFile
    [Environment]::SetEnvironmentVariable("YAZI_FILE_ONE", $gitFile, "User")
    Write-Host "Configured YAZI_FILE_ONE: $gitFile"
} else {
    Write-Warning "Git for Windows file.exe was not found at: $gitFile"
}

Set-ConfigTree `
    -Source (Join-Path $repoRoot "yazi") `
    -Destination (Join-Path $env:APPDATA "yazi\config")

$flowLauncherSource = Join-Path $repoRoot "flow-launcher"
$flowLauncherData = Join-Path $env:APPDATA "FlowLauncher"

Set-ConfigLink `
    -Path (Join-Path $flowLauncherData "Settings\Settings.json") `
    -Target (Join-Path $flowLauncherSource "Settings.json")

Set-ConfigLink `
    -Path (Join-Path $flowLauncherData "Themes\Tokyo Mocha.xaml") `
    -Target (Join-Path $flowLauncherSource "themes\Tokyo Mocha.xaml")

Set-ConfigLink `
    -Path (Join-Path $flowLauncherData "Settings\Plugins\Flow.Launcher.Plugin.Explorer\Settings.json") `
    -Target (Join-Path $flowLauncherSource "plugins\explorer\Settings.json")

Set-ConfigLink `
    -Path (Join-Path $flowLauncherData "Settings\Plugins\Flow.Launcher.Plugin.WebSearch\Settings.json") `
    -Target (Join-Path $flowLauncherSource "plugins\web-search\Settings.json")

Set-ConfigLink `
    -Path (Join-Path $HOME ".config\opencode\opencode.jsonc") `
    -Target (Join-Path $repoRoot "opencode\opencode.jsonc")

Set-ConfigLink `
    -Path (Join-Path $HOME ".config\opencode\tui.json") `
    -Target (Join-Path $repoRoot "opencode\tui.json")

Set-ConfigTree `
    -Source (Join-Path $repoRoot "opencode\plugins") `
    -Destination (Join-Path $HOME ".config\opencode\plugins")

Set-ConfigLink `
    -Path (Join-Path $HOME ".glzr\glazewm\config.yaml") `
    -Target (Join-Path $repoRoot "glzr\glazewm\config.yaml")

Set-ConfigLink `
    -Path (Join-Path $HOME ".glzr\zebar\settings.json") `
    -Target (Join-Path $repoRoot "glzr\zebar\settings.json")

$runKey = "HKCU:\Software\Microsoft\Windows\CurrentVersion\Run"
$startupApps = @(
    @{
        Name = "GlazeWM"
        Path = Join-Path $env:ProgramFiles "glzr.io\GlazeWM\glazewm.exe"
    },
    @{
        Name = "YASB"
        Path = Join-Path $env:ProgramFiles "YASB\yasb.exe"
    },
    @{
        Name = "Flow.Launcher"
        Path = Join-Path $env:LOCALAPPDATA "FlowLauncher\Flow.Launcher.exe"
    }
)

foreach ($app in $startupApps) {
    if (Test-Path -LiteralPath $app.Path) {
        Set-ItemProperty -LiteralPath $runKey -Name $app.Name -Value $app.Path
        Write-Host "Configured startup: $($app.Name) -> $($app.Path)"
    } else {
        Write-Warning "$($app.Name) is not installed at: $($app.Path)"
    }
}

$everythingPath = Join-Path $env:ProgramFiles "Everything\Everything.exe"
if (Test-Path -LiteralPath $everythingPath) {
    Set-ItemProperty `
        -LiteralPath $runKey `
        -Name "Everything" `
        -Value "`"$everythingPath`" -startup"
    Write-Host "Configured background startup: Everything -> $everythingPath"
}

$yasbConfig = Join-Path $HOME ".config\yasb"
$yasbSource = Join-Path $repoRoot "yasb"

Set-ConfigTree `
    -Source $yasbSource `
    -Destination $yasbConfig

Move-LegacyGitMetadata -ConfigPath $weztermConfig
Move-LegacyGitMetadata -ConfigPath $nushellConfig
Move-LegacyGitMetadata -ConfigPath $yasbConfig

if (Get-Command "ya" -ErrorAction SilentlyContinue) {
    & ya pkg install
}

if (-not $SkipNilesoft) {
    $nilesoftTarget = Join-Path $env:ProgramFiles "Nilesoft Shell"
    $nilesoftSource = Join-Path $repoRoot "nilesoft-shell"

    if (-not (Test-Path -LiteralPath $nilesoftTarget)) {
        Write-Warning "Nilesoft Shell is not installed at: $nilesoftTarget"
    } else {
        Set-ConfigLink `
            -Path (Join-Path $nilesoftTarget "shell.nss") `
            -Target (Join-Path $nilesoftSource "shell.nss")

        Get-ChildItem -LiteralPath (Join-Path $nilesoftSource "imports") -File | ForEach-Object {
            Set-ConfigLink `
                -Path (Join-Path $nilesoftTarget "imports\$($_.Name)") `
                -Target $_.FullName
        }

        & (Join-Path $nilesoftTarget "shell.exe") -restart -silent
        Write-Host "Linked and reloaded Nilesoft Shell configuration."
    }
}
