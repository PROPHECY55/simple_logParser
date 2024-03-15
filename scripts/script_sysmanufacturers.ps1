$logPathFile = Join-Path -Path $PSScriptRoot -ChildPath "..\logPath.txt"
$folderPath = Get-Content $logPathFile

$logFiles = Get-ChildItem -Path $folderPath -Filter *.log

$sysmanufacturers = @()

foreach ($logFile in $logFiles) {
    $content = Get-Content $logFile.FullName
    
    $sysmanufacturerFound = $false
    
    foreach ($line in $content) {
        if ($line -match "Systemhersteller:                              |Systemhersteller:                       |System Manufacturer:") {
            $sysmanufacturer = $line -replace "Systemhersteller:                              |Systemhersteller:                       |System Manufacturer:", ""

            $sysmanufacturer = $sysmanufacturer.Trim()

            $sysmanufacturers += $sysmanufacturer
            
            $sysmanufacturerFound = $true

            break
        }
    }
    
    if (-not $sysmanufacturerFound) {
        $sysmanufacturers += "-//-"
    }
}

$currentDirectory = Split-Path -Parent $MyInvocation.MyCommand.Path
$logsFolderPath = Join-Path $currentDirectory "..\logs"
$outputPath = Join-Path $logsFolderPath "log_sysmanufacturers.txt"
$sysmanufacturers -join "`r`n" | Set-Content -Path $outputPath