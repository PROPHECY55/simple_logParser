$logPathFile = Join-Path -Path $PSScriptRoot -ChildPath "..\logPath.txt"
$folderPath = Get-Content $logPathFile

$logFiles = Get-ChildItem -Path $folderPath -Filter *.log

$installdates = @()

foreach ($logFile in $logFiles) {
    $content = Get-Content $logFile.FullName
    
    $installdateFound = $false
    
    foreach ($line in $content) {
        if ($line -match "Ursprngliches Installationsdatum:|Original Install Date:") {
            $installdate = $line -replace "Ursprngliches Installationsdatum:|Original Install Date:", ""

            $installdate = $installdate.Trim()

            $installdates += $installdate

            $installdateFound = $true

            break
        }
    }
    
    if (-not $installdateFound) {
        $installdates += "-//-"
    }
}

$currentDirectory = Split-Path -Parent $MyInvocation.MyCommand.Path
$logsFolderPath = Join-Path $currentDirectory "..\logs"
$outputPath = Join-Path $logsFolderPath "log_installdates.txt"
$installdates -join "`r`n" | Set-Content -Path $outputPath