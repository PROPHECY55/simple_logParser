$logPathFile = Join-Path -Path $PSScriptRoot -ChildPath "..\logPath.txt"
$folderPath = Get-Content $logPathFile

$logFiles = Get-ChildItem -Path $folderPath -Filter *.log

$ethernetadapters = @()

foreach ($logFile in $logFiles) {
    $content = Get-Content $logFile.FullName

    $ethernetadapter = "-//-"

    $ethernetadapterCount = 0

    for ($i = 0; $i -lt $content.Count; $i++) {
        $line = $content[$i]
        if ($line -match "Ethernet adapter |Ethernet-Adapter ") {
            $ethernetadapterCount++
            if ($ethernetadapterCount -eq 2) {
                $ethernetadapter = $line -replace "Ethernet adapter |Ethernet-Adapter ", ""
                $ethernetadapter = $ethernetadapter.Trim()
                $ethernetadapter = $ethernetadapter.Substring(0, $ethernetadapter.Length - 1)
                break
            }
        }
    }

    $ethernetadapters += $ethernetadapter
}

if ($ethernetadapters.Count -lt $logFiles.Count) {
    $ethernetadapters += "-//-" * ($logFiles.Count - $ethernetadapters.Count)
}

$currentDirectory = Split-Path -Parent $MyInvocation.MyCommand.Path
$logsFolderPath = Join-Path $currentDirectory "..\logs"
$outputPath = Join-Path $logsFolderPath "log_ethernetadapter_2.txt"
$ethernetadapters -join "`r`n" | Set-Content -Path $outputPath