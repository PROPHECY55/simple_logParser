$logPathFile = Join-Path -Path $PSScriptRoot -ChildPath "..\logPath.txt"
$folderPath = Get-Content $logPathFile

$logFiles = Get-ChildItem -Path $folderPath -Filter *.log

$physicaladresses = @()

foreach ($logFile in $logFiles) {
    $content = Get-Content $logFile.FullName
    
    $physicaladressFound = $false
    
    foreach ($line in $content) {
        if ($line -match "Physical Address. . . . . . . . . :|Physische Adresse . . . . . . . . :") {
            $physicaladress = $line -replace "Physical Address. . . . . . . . . :|Physische Adresse . . . . . . . . :", ""

            $physicaladress = $physicaladress.Trim()

            $physicaladresses += $physicaladress
            
            $physicaladressFound = $true

            break
        }
    }
    
    if (-not $physicaladressFound) {
        $physicaladresses += "-//-"
    }
}

$currentDirectory = Split-Path -Parent $MyInvocation.MyCommand.Path
$logsFolderPath = Join-Path $currentDirectory "..\logs"
$outputPath = Join-Path $logsFolderPath "log_physicaladresses.txt"
$physicaladresses -join "`r`n" | Set-Content -Path $outputPath