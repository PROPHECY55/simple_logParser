$logPathFile = Join-Path -Path $PSScriptRoot -ChildPath "..\logPath.txt"
$folderPath = Get-Content $logPathFile

$logFiles = Get-ChildItem -Path $folderPath -Filter *.log

$physicaladresses = @()

foreach ($logFile in $logFiles) {
    $content = Get-Content $logFile.FullName

    $physicaladress = "-//-"
    $physicaladressCount = 0
    $stopProcessing = $false

    foreach ($line in $content) {
        if ($stopProcessing) {
            break
        }

        if ($line -match "Tunnel adapter ") {
            $physicaladress = "-//-"
            $stopProcessing = $true
        } elseif ($line -match "Physical Address. . . . . . . . . :|Physische Adresse . . . . . . . . :") {
            $physicaladressCount++
            if ($physicaladressCount -eq 2) {
                $physicaladress = $line -replace "Physical Address. . . . . . . . . :|Physische Adresse . . . . . . . . :", ""
                $physicaladress = $physicaladress.Trim()
                $stopProcessing = $true
            }
        }
    }

    $physicaladresses += $physicaladress
}

if ($physicaladresses.Count -lt $logFiles.Count) {
    $physicaladresses += "-//-" * ($logFiles.Count - $physicaladresses.Count)
}

$currentDirectory = Split-Path -Parent $MyInvocation.MyCommand.Path
$logsFolderPath = Join-Path $currentDirectory "..\logs"
$outputPath = Join-Path $logsFolderPath "log_physicaladresses_2.txt"
$physicaladresses -join "`r`n" | Set-Content -Path $outputPath