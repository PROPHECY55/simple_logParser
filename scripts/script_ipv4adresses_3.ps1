$logPathFile = Join-Path -Path $PSScriptRoot -ChildPath "..\logPath.txt"
$folderPath = Get-Content $logPathFile
$ipv4addresses = @()

Get-ChildItem -Path $folderPath -Filter *.log | ForEach-Object {
    $content = Get-Content $_.FullName
    $startindex = -1
    $endindex = -1
    $skipCount = 0

    for ($i = 0; $i -lt $content.Count; $i++) {
        if ($content[$i] -match "Ethernet adapter |Ethernet-Adapter ") {
            if ($skipCount -lt 2) {
                $skipCount++
                continue
            }

            if ($startindex -eq -1) {
                $startindex = $i
            } else {
                $endindex = $i
                break
            }
        }
    }

    if ($startindex -ne -1) {
        if ($endindex -eq -1) {
            $endindex = $content.Count
        }

        $ipv4addressesString = ""
        for ($i = $startindex + 1; $i -lt $endindex; $i++) {
            if ($content[$i] -match "(IPv4 Address|IP Address|IPv4-Adresse).*?:\s*(\d+\.\d+\.\d+\.\d+)") {
                $matches = [regex]::Match($content[$i], "(IPv4 Address|IP Address|IPv4-Adresse).*?:\s*(\d+\.\d+\.\d+\.\d+)")
                $ipv4address = $matches.Groups[2].Value
                $ipv4addressesString += $ipv4address + "`r`n"
            }
        }
        if ($ipv4addressesString -eq "") {
            $ipv4addressesString = "-//-"
        }
        $ipv4addresses += $ipv4addressesString
    } else {
        $ipv4addresses += "-//-"
    }
}

$outputPath = Join-Path (Split-Path -Parent $MyInvocation.MyCommand.Path) "..\logs\log_ipv4adresses_3.txt"
$ipv4addresses = $ipv4addresses -replace "(`r`n)+$", ""
$ipv4addresses -join "`r`n" | Set-Content -Path $outputPath