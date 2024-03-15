$logPathFile = Join-Path -Path $PSScriptRoot -ChildPath "..\logPath.txt"
$folderPath = Get-Content $logPathFile

$logFiles = Get-ChildItem -Path $folderPath -Filter *.log

$totalmemories = @()

foreach ($logFile in $logFiles) {
    $content = Get-Content $logFile.FullName
    
    $totalmemoryFound = $false
    
    foreach ($line in $content) {
        if ($line -match "Gesamter physischer Speicher:|Gesamter physikalischer Speicher:|Total Physical Memory:") {
            $totalmemory = $line -replace "Gesamter physischer Speicher:|Gesamter physikalischer Speicher:|Total Physical Memory:", ""

            $totalmemory = $totalmemory.Trim()

            $totalmemories += $totalmemory
            
            $totalmemoryFound = $true

            break
        }
    }
    
    if (-not $totalmemoryFound) {
        $totalmemories += "-//-"
    }
}

$currentDirectory = Split-Path -Parent $MyInvocation.MyCommand.Path
$logsFolderPath = Join-Path $currentDirectory "..\logs"
$outputPath = Join-Path $logsFolderPath "log_totalmemories.txt"
$totalmemories -join "`r`n" | Set-Content -Path $outputPath