$logPathFile = Join-Path -Path $PSScriptRoot -ChildPath "..\logPath.txt"
$folderPath = Get-Content $logPathFile
$subnetmasks = @()

Get-ChildItem -Path $folderPath -Filter *.log | ForEach-Object {
    $content = Get-Content $_.FullName
    $startindex = -1
    $endindex = -1

    for ($i = 0; $i -lt $content.Count; $i++) {
        if ($content[$i] -match "Ethernet adapter |Ethernet-Adapter ") {
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

        $subnetmasksString = ""
        for ($i = $startindex + 1; $i -lt $endindex; $i++) {
            if ($content[$i] -match "(Subnet Mask|Subnetzmaske).*?:\s*(\d+\.\d+\.\d+\.\d+)") {
                $matches = [regex]::Match($content[$i], "(Subnet Mask|Subnetzmaske).*?:\s*(\d+\.\d+\.\d+\.\d+)")
                $subnetmask = $matches.Groups[2].Value
                $subnetmasksString += $subnetmask + "`r`n"
            }
        }
        if ($subnetmasksString -eq "") {
            $subnetmasksString = "-//-"
        }
        $subnetmasks += $subnetmasksString
    } else {
        $subnetmasks += "-//-"
    }
}

$outputPath = Join-Path (Split-Path -Parent $MyInvocation.MyCommand.Path) "..\logs\log_subnetmasks.txt"
$subnetmasks = $subnetmasks -replace "(`r`n)+$", ""
$subnetmasks -join "`r`n" | Set-Content -Path $outputPath