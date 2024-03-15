$logPathFile = Join-Path -Path $PSScriptRoot -ChildPath "..\logPath.txt"
$folderPath = Get-Content $logPathFile

$logFiles = Get-ChildItem -Path $folderPath -Filter *.log

$ethernetdescriptions = @()

foreach ($logFile in $logFiles) {
    $content = Get-Content $logFile.FullName

    $ethernetdescription = "-//-"
    $ethernetdescriptionCount = 0
    $ethernetadapterCount = 0
    $stopProcessing = $false

    foreach ($line in $content) {
        if ($stopProcessing) {
            break
        }

        if ($line -match "Tunnel adapter ") {
            $ethernetdescription = "-//-"
            $stopProcessing = $true
        } elseif ($line -match "Description . . . . . . . . . . . :|Beschreibung. . . . . . . . . . . :") {
            $ethernetdescriptionCount++
            if ($ethernetdescriptionCount -eq 3) {
                $ethernetdescription = $line -replace "Description . . . . . . . . . . . :|Beschreibung. . . . . . . . . . . :", ""
                $ethernetdescription = $ethernetdescription.Trim()
                $stopProcessing = $true
            }
        }

        if ($line -match "Ethernet adapter |Ethernet-Adapter ") {
            $ethernetadapterCount++
        }
    }

    if ($ethernetadapterCount -gt $ethernetdescriptionCount) {
        $ethernetdescription = "-//-/"
    }

    $ethernetdescriptions += $ethernetdescription
}

if ($ethernetdescriptions.Count -lt $logFiles.Count) {
    $ethernetdescriptions += "-//-" * ($logFiles.Count - $ethernetdescriptions.Count)
}

$currentDirectory = Split-Path -Parent $MyInvocation.MyCommand.Path
$logsFolderPath = Join-Path $currentDirectory "..\logs"
$outputPath = Join-Path $logsFolderPath "log_ethernetdescriptions_3.txt"
$ethernetdescriptions -join "`r`n" | Set-Content -Path $outputPath