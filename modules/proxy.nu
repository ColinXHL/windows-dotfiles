def --env proxy-on [] {
    let proxy = "http://127.0.0.1:7890"

    $env.HTTP_PROXY = $proxy
    $env.HTTPS_PROXY = $proxy
    $env.NO_PROXY = "localhost,127.0.0.1,::1"
}

def --env proxy-off [] {
    hide-env --ignore-errors HTTP_PROXY HTTPS_PROXY NO_PROXY
}

proxy-on
