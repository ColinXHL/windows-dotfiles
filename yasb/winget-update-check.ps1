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

if ($separatorIndex -lt 0) {
    exit 0
}

$count = 0
for ($i = $separatorIndex + 1; $i -lt $lines.Count; $i++) {
    $line = $lines[$i].TrimEnd()
    if ($line -match "^\s*.+\s+[A-Za-z0-9][A-Za-z0-9._+-]+\s+\S+\s+\S+\s+\S+\s*$") {
        $count++
    }
}

if ($count -gt 0) {
    [Console]::Out.Write($count)
}
