$ErrorActionPreference = "Stop"
[Console]::OutputEncoding = [Text.UTF8Encoding]::new()

$city = "350211"
$apiKey = [Environment]::GetEnvironmentVariable("AMAP_WEATHER_API_KEY", "User")
$cachePath = Join-Path $env:LOCALAPPDATA "YASB\amap_weather_cache.json"
$utf8 = [Text.UTF8Encoding]::new($false)

function Invoke-AmapWeather([string]$extension) {
    if ([string]::IsNullOrWhiteSpace($apiKey)) {
        throw "AMAP_WEATHER_API_KEY is not configured."
    }

    $escapedKey = [Uri]::EscapeDataString($apiKey)
    $url = "https://restapi.amap.com/v3/weather/weatherInfo?city=$city&key=$escapedKey&extensions=$extension&output=JSON"
    $output = & curl.exe --silent --show-error --fail --max-time 15 $url
    if ($LASTEXITCODE -ne 0) {
        throw "Amap weather request failed."
    }

    $response = ($output -join "") | ConvertFrom-Json
    if ($response.status -ne "1") {
        throw "Amap weather API error: $($response.info)"
    }
    return $response
}

function Get-WeatherIcon([string]$weather) {
    if ($weather.Contains([string][char]0x96F7)) { return [char]::ConvertFromUtf32(0xE30F) }
    if ($weather.Contains([string][char]0x96E8)) { return [char]::ConvertFromUtf32(0xF067E) }
    if ($weather.Contains([string][char]0x96EA)) { return [char]::ConvertFromUtf32(0xF0D98) }
    if ($weather.Contains([string][char]0x96FE) -or $weather.Contains([string][char]0x973E)) {
        return [char]::ConvertFromUtf32(0xE303)
    }
    if ($weather.Contains([string][char]0x4E91) -or $weather.Contains([string][char]0x9634)) {
        return [char]::ConvertFromUtf32(0xE312)
    }
    if ($weather.Contains([string][char]0x6674)) { return [char]::ConvertFromUtf32(0xE30D) }
    return [char]::ConvertFromUtf32(0xEBAA)
}

function Get-WeatherColor([string]$weather) {
    if ($weather.Contains([string][char]0x96F7)) { return "#F38BA8" }
    if ($weather.Contains([string][char]0x96E8)) { return "#89B4FA" }
    if ($weather.Contains([string][char]0x96EA)) { return "#CDD6F4" }
    if ($weather.Contains([string][char]0x96FE) -or $weather.Contains([string][char]0x973E)) {
        return "#9399B2"
    }
    if ($weather.Contains([string][char]0x4E91) -or $weather.Contains([string][char]0x9634)) {
        return "#A6ADC8"
    }
    if ($weather.Contains([string][char]0x6674)) { return "#F9E2AF" }
    return "#CBA6F7"
}

function Format-Forecast($forecast) {
    $condition = $forecast.dayweather
    if ($forecast.dayweather -ne $forecast.nightweather) {
        $condition = "$($forecast.dayweather)/$($forecast.nightweather)"
    }
    return "$condition $($forecast.daytemp)/$($forecast.nighttemp)"
}

try {
    $current = Invoke-AmapWeather "base"
    $forecast = Invoke-AmapWeather "all"
    $live = $current.lives[0]
    $days = $forecast.forecasts[0].casts
    $currentIcon = Get-WeatherIcon $live.weather
    $currentColor = Get-WeatherColor $live.weather
    $degree = [char]0x00B0

    $data = [ordered]@{
        bar = "<span style=`"font-size:16px;vertical-align:middle;color:$currentColor`">$currentIcon</span> <span style=`"font-size:12px;vertical-align:middle`">$($live.weather) $($live.temperature)$degree" + "C</span>"
        icon = $currentIcon
        color = $currentColor
        city = $live.city
        weather = $live.weather
        temp = $live.temperature
        humidity = $live.humidity
        wind = "$($live.winddirection) $($live.windpower)"
        report = $live.reporttime
        day0 = Format-Forecast $days[0]
        day1 = Format-Forecast $days[1]
        day2 = Format-Forecast $days[2]
        day3 = Format-Forecast $days[3]
        day0Icon = Get-WeatherIcon $days[0].dayweather
        day1Icon = Get-WeatherIcon $days[1].dayweather
        day2Icon = Get-WeatherIcon $days[2].dayweather
        day3Icon = Get-WeatherIcon $days[3].dayweather
        day0Color = Get-WeatherColor $days[0].dayweather
        day1Color = Get-WeatherColor $days[1].dayweather
        day2Color = Get-WeatherColor $days[2].dayweather
        day3Color = Get-WeatherColor $days[3].dayweather
        day0Weather = $days[0].dayweather
        day1Weather = $days[1].dayweather
        day2Weather = $days[2].dayweather
        day3Weather = $days[3].dayweather
        day0High = $days[0].daytemp
        day1High = $days[1].daytemp
        day2High = $days[2].daytemp
        day3High = $days[3].daytemp
        day0Low = $days[0].nighttemp
        day1Low = $days[1].nighttemp
        day2Low = $days[2].nighttemp
        day3Low = $days[3].nighttemp
        day0Date = $days[0].date.Substring(5).Replace("-", "/")
        day1Date = $days[1].date.Substring(5).Replace("-", "/")
        day2Date = $days[2].date.Substring(5).Replace("-", "/")
        day3Date = $days[3].date.Substring(5).Replace("-", "/")
    }

    $json = $data | ConvertTo-Json -Compress
    [IO.File]::WriteAllText($cachePath, $json, $utf8)
    $json
}
catch {
    if (Test-Path -LiteralPath $cachePath) {
        [IO.File]::ReadAllText($cachePath, $utf8)
    }
    else {
        '{"icon":"","city":"","weather":"N/A","temp":"--","humidity":"--","wind":"--","report":"--","day0":"--","day1":"--","day2":"--","day3":"--"}'
    }
}
