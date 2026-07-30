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

Set-ConfigLink `
    -Path (Join-Path $HOME ".config\wezterm") `
    -Target (Join-Path $repoRoot "wezterm")

Set-ConfigLink `
    -Path (Join-Path $HOME ".config\nushell") `
    -Target (Join-Path $repoRoot "nushell")

Set-ConfigLink `
    -Path (Join-Path $HOME ".config\starship.toml") `
    -Target (Join-Path $repoRoot "nushell\starship.toml")

Set-ConfigLink `
    -Path (Join-Path $env:APPDATA "nushell\config.nu") `
    -Target (Join-Path $repoRoot "nushell\config.nu")

Set-ConfigLink `
    -Path (Join-Path $HOME ".config\opencode\opencode.jsonc") `
    -Target (Join-Path $repoRoot "opencode\opencode.jsonc")

Set-ConfigLink `
    -Path (Join-Path $HOME ".config\opencode\tui.json") `
    -Target (Join-Path $repoRoot "opencode\tui.json")

if (-not $SkipNilesoft) {
    $nilesoftTarget = Join-Path $env:ProgramFiles "Nilesoft Shell"
    $nilesoftSource = Join-Path $repoRoot "nilesoft-shell"

    if (-not (Test-Path -LiteralPath $nilesoftTarget)) {
        Write-Warning "Nilesoft Shell is not installed at: $nilesoftTarget"
    } else {
        Copy-Item `
            -LiteralPath (Join-Path $nilesoftSource "shell.nss") `
            -Destination (Join-Path $nilesoftTarget "shell.nss") `
            -Force

        Get-ChildItem -LiteralPath (Join-Path $nilesoftSource "imports") -File | ForEach-Object {
            Copy-Item `
                -LiteralPath $_.FullName `
                -Destination (Join-Path $nilesoftTarget "imports\$($_.Name)") `
                -Force
        }

        & (Join-Path $nilesoftTarget "shell.exe") -restart -silent
        Write-Host "Installed and reloaded Nilesoft Shell configuration."
    }
}
