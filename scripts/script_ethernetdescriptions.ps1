$logPathFile = Join-Path -Path $PSScriptRoot -ChildPath "..\logPath.txt"
$folderPath = Get-Content $logPathFile

$logFiles = Get-ChildItem -Path $folderPath -Filter *.log

$ethernetdescriptions = @()

foreach ($logFile in $logFiles) {
    $content = Get-Content $logFile.FullName
    
    $ethernetdescriptionFound = $false
    
    foreach ($line in $content) {
        if ($line -match "Description . . . . . . . . . . . :|Beschreibung. . . . . . . . . . . :") {
            $ethernetdescription = $line -replace "Description . . . . . . . . . . . :|Beschreibung. . . . . . . . . . . :", ""

            $ethernetdescription = $ethernetdescription.Trim()

            $ethernetdescriptions += $ethernetdescription
            
            $ethernetdescriptionFound = $true

            break
        }
    }
    
    if (-not $ethernetdescriptionFound) {
        $ethernetdescriptions += "-//-"
    }
}

$currentDirectory = Split-Path -Parent $MyInvocation.MyCommand.Path
$logsFolderPath = Join-Path $currentDirectory "..\logs"
$outputPath = Join-Path $logsFolderPath "log_ethernetdescriptions.txt"
$ethernetdescriptions -join "`r`n" | Set-Content -Path $outputPath