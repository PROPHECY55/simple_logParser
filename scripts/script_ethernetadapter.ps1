$logPathFile = Join-Path -Path $PSScriptRoot -ChildPath "..\logPath.txt"
$folderPath = Get-Content $logPathFile
$ethernetadapters = @()

Get-ChildItem -Path $folderPath -Filter *.log | ForEach-Object {
    $ethernetadapterFound = $false
    $content = Get-Content $_.FullName

    foreach ($line in $content) {
        if ($line -match "Ethernet adapter |Ethernet-Adapter ") {
            $ethernetadapter = $line -replace "Ethernet adapter |Ethernet-Adapter ", "" -replace ".$"
            $ethernetadapters += $ethernetadapter.Trim()
            $ethernetadapterFound = $true
            break
        }
    }

    if (-not $ethernetadapterFound) {
        $ethernetadapters += "-//-"
    }
}

$outputPath = Join-Path (Split-Path -Parent $MyInvocation.MyCommand.Path) "..\logs\log_ethernetadapter.txt"
$ethernetadapters -join "`r`n" | Set-Content -Path $outputPath