$logPathFile = Join-Path -Path $PSScriptRoot -ChildPath "..\logPath.txt"
$folderPath = Get-Content $logPathFile

$logFiles = Get-ChildItem -Path $folderPath -Filter *.log

$osnames = @()

foreach ($logFile in $logFiles) {
    $content = Get-Content $logFile.FullName
    
    $osnameFound = $false
    
    foreach ($line in $content) {
        if ($line -match "Betriebssystemname:|OS Name:") {
            $osname = $line -replace "Betriebssystemname:|OS Name:", ""

            $osname = $osname.Trim()

            $osnames += $osname
            
            $osnameFound = $true

            break
        }
    }
    
    if (-not $osnameFound) {
        $osnames += "-//-"
    }
}

$currentDirectory = Split-Path -Parent $MyInvocation.MyCommand.Path
$logsFolderPath = Join-Path $currentDirectory "..\logs"
$outputPath = Join-Path $logsFolderPath "log_osnames.txt"
$osnames -join "`r`n" | Set-Content -Path $outputPath