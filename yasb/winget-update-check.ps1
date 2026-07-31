$ErrorActionPreference = "Stop"
[Console]::OutputEncoding = [Text.UTF8Encoding]::new()

$output = & winget.exe upgrade --include-unknown --accept-source-agreements --disable-interactivity
$lines = @($output)
$separatorIndex = -1

for ($i = 0; $i -lt $lines.Count; $i++) {
    if ($lines[$i] -match "^-{3,}") {
        $separatorIndex = $i
        break
    }
}

$updates = [Collections.Generic.List[object]]::new()
if ($separatorIndex -ge 0) {
    for ($i = $separatorIndex + 1; $i -lt $lines.Count; $i++) {
        $line = $lines[$i].Trim()
        if ([string]::IsNullOrWhiteSpace($line)) {
            if ($updates.Count -gt 0) { break }
            continue
        }

        if ($line -notmatch "^(?<name>.+)\s+(?<id>\S+)\s+(?<current>\S+)\s+(?<available>\S+)\s+(?<source>\S+)$") {
            continue
        }

        $updates.Add([pscustomobject]@{
            Name = $Matches.name.Trim()
            CurrentVersion = $Matches.current
            AvailableVersion = $Matches.available
        })
    }
}

if ($updates.Count -eq 0) {
    exit 0
}
$details = @("Available Winget updates:")
$details += $updates | ForEach-Object {
    "- $($_.Name)  $($_.CurrentVersion) -> $($_.AvailableVersion)"
}
$details += "Checked: $(Get-Date -Format 'HH:mm:ss')"

[ordered]@{
    count = $updates.Count
    details = $details -join "`n"
} | ConvertTo-Json -Compress
