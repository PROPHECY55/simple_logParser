$logPathFile = Join-Path -Path $PSScriptRoot -ChildPath "..\logPath.txt"
$folderPath = Get-Content $logPathFile

$logFiles = Get-ChildItem -Path $folderPath -Filter *.log

$osversions = @()

foreach ($logFile in $logFiles) {
    $content = Get-Content $logFile.FullName
    
    $osversionFound = $false
    
    foreach ($line in $content) {
        if ($line -match "Betriebssystemversion:|OS Version:") {
            $osversion = $line -replace "Betriebssystemversion:|OS Version:", ""

            $osversion = $osversion.Trim()

            $osversions += $osversion
            
            $osversionFound = $true

            break
        }
    }
    
    if (-not $osversionFound) {
        $osversions += "-//-"
    }
}

$currentDirectory = Split-Path -Parent $MyInvocation.MyCommand.Path
$logsFolderPath = Join-Path $currentDirectory "..\logs"
$outputPath = Join-Path $logsFolderPath "log_osversions.txt"
$osversions -join "`r`n" | Set-Content -Path $outputPath