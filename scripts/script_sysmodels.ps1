$logPathFile = Join-Path -Path $PSScriptRoot -ChildPath "..\logPath.txt"
$folderPath = Get-Content $logPathFile

$logFiles = Get-ChildItem -Path $folderPath -Filter *.log

$sysmodels = @()

foreach ($logFile in $logFiles) {
    $content = Get-Content $logFile.FullName
    
    $sysmodelFound = $false
    
    foreach ($line in $content) {
        if ($line -match "Systemmodell:|System Model:") {
            $sysmodel = $line -replace "Systemmodell:|System Model:", ""

            $sysmodel = $sysmodel.Trim()

            $sysmodels += $sysmodel
            
            $sysmodelFound = $true

            break
        }
    }
    
    if (-not $sysmodelFound) {
        $sysmodels += "-//-"
    }
}

$currentDirectory = Split-Path -Parent $MyInvocation.MyCommand.Path
$logsFolderPath = Join-Path $currentDirectory "..\logs"
$outputPath = Join-Path $logsFolderPath "log_sysmodels.txt"
$sysmodels -join "`r`n" | Set-Content -Path $outputPath