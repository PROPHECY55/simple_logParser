$logPathFile = Join-Path -Path $PSScriptRoot -ChildPath "..\logPath.txt"
$folderPath = Get-Content $logPathFile
$ipv4addresses = @()

Get-ChildItem -Path $folderPath -Filter *.log | ForEach-Object {
    $content = Get-Content $_.FullName
    $startindex = -1
    $endindex = -1
    $firstAdapterFound = $false

    for ($i = 0; $i -lt $content.Count; $i++) {
        if ($content[$i] -match "Ethernet adapter |Ethernet-Adapter ") {
            if (!$firstAdapterFound) {
                $firstAdapterFound = $true
            } elseif ($startindex -eq -1) {
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

        $ipv4addressesArray = @()
        for ($i = $startindex + 1; $i -lt $endindex; $i++) {
            if ($content[$i] -match "(IPv4 Address|IP Address|IPv4-Adresse).*?:\s*(\d+\.\d+\.\d+\.\d+)") {
                $matches = [regex]::Match($content[$i], "(IPv4 Address|IP Address|IPv4-Adresse).*?:\s*(\d+\.\d+\.\d+\.\d+)")
                $ipv4address = $matches.Groups[2].Value
                $ipv4addressesArray += $ipv4address
            }
        }
        if ($ipv4addressesArray.Count -gt 0) {
            $ipv4addressesString = $ipv4addressesArray -join " & "
        } else {
            $ipv4addressesString = "-//-"
        }
        $ipv4addresses += $ipv4addressesString
    } else {
        $ipv4addresses += "-//-"
    }
}

$outputPath = Join-Path (Split-Path -Parent $MyInvocation.MyCommand.Path) "..\logs\log_ipv4adresses_2.txt"
$ipv4addresses = $ipv4addresses -replace "(`r`n)+$", ""
$ipv4addresses -join "`r`n" | Set-Content -Path $outputPath