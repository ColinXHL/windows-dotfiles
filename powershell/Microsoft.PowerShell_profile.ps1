$env:http_proxy="http://127.0.0.1:7890"
$env:https_proxy="http://127.0.0.1:7890"

Invoke-Expression (& { (zoxide init powershell | Out-String) })

function y {
    $tmp = New-TemporaryFile

    yazi $args --cwd-file="$tmp"

    if (Get-Content $tmp) {
        Set-Location (Get-Content $tmp)
    }

    Remove-Item $tmp
}

$env:VISUAL="nvim"
$env:EDITOR="nvim"
