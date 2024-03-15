$logPathFile = Join-Path -Path $PSScriptRoot -ChildPath "..\logPath.txt"
$folderPath = Get-Content $logPathFile

$logFiles = Get-ChildItem -Path $folderPath -Filter *.log

$iphostnames = @()

foreach ($logFile in $logFiles) {
    $content = Get-Content $logFile.FullName
    
    $iphostnameFound = $false
    
    foreach ($line in $content) {
        if ($line -match "Host Name . . . . . . . . . . . . :|Hostname  . . . . . . . . . . . . :") {
            $iphostname = $line -replace "Host Name . . . . . . . . . . . . :|Hostname  . . . . . . . . . . . . :", ""

            $iphostname = $iphostname.Trim()

            $iphostnames += $iphostname
            
            $iphostnameFound = $true

            break
        }
    }
    
    if (-not $iphostnameFound) {
        $iphostnames += "-//-"
    }
}

$currentDirectory = Split-Path -Parent $MyInvocation.MyCommand.Path
$logsFolderPath = Join-Path $currentDirectory "..\logs"
$outputPath = Join-Path $logsFolderPath "log_hostnames.txt"
$iphostnames -join "`r`n" | Set-Content -Path $outputPath