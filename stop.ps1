# Change to the correct working directory (see https://stackoverflow.com/questions/4724290/powershell-run-command-from-scripts-directory)
$scriptpath = $MyInvocation.MyCommand.Path
$dir = Split-Path $scriptpath
cd $dir

[xml] $scriptConfig = Get-Content "scriptConfig.xml"

$server = Get-Process FXServer -ErrorAction SilentlyContinue

if ($server) {
    # Send HTTP request to server process to do shutdown
    try {
        $body = ConvertTo-Json @{
            api_key = $scriptConfig.Config.APIKey
            type = 'restart'
            params = {}
        }

        Invoke-WebRequest -Uri $scriptConfig.Config.Endpoint -Method 'POST' -ContentType 'application/json' -Body $body -UseBasicParsing

        Start-Sleep -Seconds 10
    } catch {
        echo 'Failed to invoke restart script - data may not sync properly'
        echo $_
    }

    taskkill /IM FXServer.exe /F
    taskkill /IM FXServer.exe /F
    taskkill /IM FXServer.exe /F
    taskkill /IM FXServer.exe /F
}