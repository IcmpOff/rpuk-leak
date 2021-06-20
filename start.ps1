# Change to the correct working directory (see https://stackoverflow.com/questions/4724290/powershell-run-command-from-scripts-directory)
$scriptpath = $MyInvocation.MyCommand.Path
$dir = Split-Path $scriptpath
cd $dir

if (!(Test-Path "logs/")) {
    New-Item -ItemType Directory -Path logs/
}

. "$dir\stop.ps1"

function Tee-ObjectNoColor {
    [CmdletBinding()]
    Param(
        [Parameter(Position=0, Mandatory=$true)]
        [string]$FilePath,

        [Parameter(Position=1, Mandatory=$false, ValueFromPipeline=$true)]
        [string]$InputObject
    )

    process {
        if (-Not $InputObject -Eq "") {
            $Time = Get-Date -Format "[yyyy-MM-dd HH:mm:ss.fff K]"
            $CleanedObject = $InputObject -replace '\[\d+(;\d+)?m'
            "$Time $CleanedObject" | Out-File $FilePath -Append
        }

        $InputObject | Out-Host
    }
}

# Run FXServer
$FILEDATE = Get-Date -Format "yyyy-MM-dd_HH-mm-ss"
../FXServer/FXServer.exe +exec server.cfg +set onesync on +set sv_enforceGameBuild 2189 | Tee-ObjectNoColor logs/$FILEDATE.log
