$logPathFile = Join-Path -Path $PSScriptRoot -ChildPath "..\logPath.txt"
$folderPath = Get-Content $logPathFile

$logFiles = Get-ChildItem -Path $folderPath -Filter *.log

$sqlserver = @()

foreach ($logFile in $logFiles) {
    $content = Get-Content $logFile.FullName
    
    $sqlserveFound = $false
    
    foreach ($line in $content) {
        if ($line -match "SQL Server \(|SQL Server \(") {
            $sqlserve = $line -replace "SQL Server |SQL Server ", ""

            $sqlserve = $sqlserve.Trim()

            $sqlserver += $sqlserve
            
            $sqlserveFound = $true

            break
        }
    }
    
    if (-not $sqlserveFound) {
        $sqlserver += "-//-"
    }
}

$currentDirectory = Split-Path -Parent $MyInvocation.MyCommand.Path
$logsFolderPath = Join-Path $currentDirectory "..\logs"
$outputPath = Join-Path $logsFolderPath "log_sqlserver.txt"
$sqlserver -join "`r`n" | Set-Content -Path $outputPath