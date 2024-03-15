$startTime = Get-Date
Write-Host ".__               __________                                   
|  |   ____   ____\______   \_____ _______  ______ ___________ 
|  |  /  _ \ / ___\|     ___/\__  \\_  __ \/  ___// __ \_  __ \
|  |_(  <_> ) /_/  >    |     / __ \|  | \/\___ \\  ___/|  | \/
|____/\____/\___  /|____|    (____  /__|  /____  >\___  >__|   
           /_____/                \/           \/     \/       `n"  -ForegroundColor Yellow

# Get the current directory and set paths for script files
$currentDirectory = Get-Location
$folderPath = Join-Path $currentDirectory "scripts"
$currentScriptPath = $MyInvocation.MyCommand.Path
$scriptFiles = Get-ChildItem $folderPath -Filter *.ps1 | Where-Object { $_.FullName -ne $currentScriptPath }

# Loop through and execute each script file
foreach ($scriptFile in $scriptFiles) {
    Write-Host "$($scriptFile.Name) executing..."
    try {
        Invoke-Expression -Command "powershell -NoProfile -ExecutionPolicy Bypass -File $($scriptFile.FullName)"
        Write-Host "$($scriptFile.Name) executed successfully. [SUCCESS]" -ForegroundColor Green
    } catch {
        Write-Host "Error while executing the script $($scriptFile.Name). Error: $_" -ForegroundColor Red
    }
}


# Formatting .txt files in Excel
$sourceFilePath1 = Join-Path $currentDirectory "logs\log_filenames.txt"
$sourceFilePath2 = Join-Path $currentDirectory "logs\log_hostnames.txt"
$sourceFilePath3 = Join-Path $currentDirectory "logs\log_osnames.txt"
$sourceFilePath4 = Join-Path $currentDirectory "logs\log_osversions.txt"
$sourceFilePath5 = Join-Path $currentDirectory "logs\log_installdates.txt"
$sourceFilePath6 = Join-Path $currentDirectory "logs\log_sysmanufacturers.txt"
$sourceFilePath7 = Join-Path $currentDirectory "logs\log_sysmodels.txt"
$sourceFilePath8 = Join-Path $currentDirectory "logs\log_totalmemories.txt"
$sourceFilePath9 = Join-Path $currentDirectory "logs\log_sqlserver.txt"
$sourceFilePath10 = Join-Path $currentDirectory "logs\log_ethernetadapter.txt"
$sourceFilePath11 = Join-Path $currentDirectory "logs\log_ethernetdescriptions.txt"
$sourceFilePath12 = Join-Path $currentDirectory "logs\log_physicaladresses.txt"
$sourceFilePath13 = Join-Path $currentDirectory "logs\log_ipv4adresses.txt"
$sourceFilePath14 = Join-Path $currentDirectory "logs\log_subnetmasks.txt"

$sourceFilePath15 = Join-Path $currentDirectory "logs\log_ethernetadapter_2.txt"
$sourceFilePath16 = Join-Path $currentDirectory "logs\log_ethernetdescriptions_2.txt"
$sourceFilePath17 = Join-Path $currentDirectory "logs\log_physicaladresses_2.txt"
$sourceFilePath18 = Join-Path $currentDirectory "logs\log_ipv4adresses_2.txt"
$sourceFilePath19 = Join-Path $currentDirectory "logs\log_subnetmasks_2.txt"

$sourceFilePath20 = Join-Path $currentDirectory "logs\log_ethernetadapter_3.txt"
$sourceFilePath21 = Join-Path $currentDirectory "logs\log_ethernetdescriptions_3.txt"
$sourceFilePath22 = Join-Path $currentDirectory "logs\log_physicaladresses_3.txt"
$sourceFilePath23 = Join-Path $currentDirectory "logs\log_ipv4adresses_3.txt"
$sourceFilePath24 = Join-Path $currentDirectory "logs\log_subnetmasks_3.txt"

$destinationFilePath = Join-Path $currentDirectory "_logs_finished.xlsx"

Write-Host "`nFormatting in Excel..."
$excel = New-Object -ComObject Excel.Application
$excel.Visible = $false
$excel.DisplayAlerts = $false

$workbook = $excel.Workbooks.Open($destinationFilePath)
$worksheet = $workbook.Sheets.Item(1)

function Set-WorksheetCellValue ($filePath, $column) {
    $logValues = Get-Content $filePath
    $row = 4 # Excel starting row
    foreach ($value in $logValues) {
        $worksheet.Cells.Item($row, $column) = $value
        $row++
    }
}

# Set the Excel columns
Set-WorksheetCellValue $sourceFilePath1 1
Set-WorksheetCellValue $sourceFilePath2 2
Set-WorksheetCellValue $sourceFilePath3 3
Set-WorksheetCellValue $sourceFilePath4 4
Set-WorksheetCellValue $sourceFilePath5 5
Set-WorksheetCellValue $sourceFilePath6 6
Set-WorksheetCellValue $sourceFilePath7 7
Set-WorksheetCellValue $sourceFilePath8 8
Set-WorksheetCellValue $sourceFilePath9 9
Set-WorksheetCellValue $sourceFilePath10 10
Set-WorksheetCellValue $sourceFilePath11 11
Set-WorksheetCellValue $sourceFilePath12 12
Set-WorksheetCellValue $sourceFilePath13 13
Set-WorksheetCellValue $sourceFilePath14 14

Set-WorksheetCellValue $sourceFilePath15 15
Set-WorksheetCellValue $sourceFilePath16 16
Set-WorksheetCellValue $sourceFilePath17 17
Set-WorksheetCellValue $sourceFilePath18 18
Set-WorksheetCellValue $sourceFilePath19 19

Set-WorksheetCellValue $sourceFilePath20 20
Set-WorksheetCellValue $sourceFilePath21 21
Set-WorksheetCellValue $sourceFilePath22 22
Set-WorksheetCellValue $sourceFilePath23 23
Set-WorksheetCellValue $sourceFilePath24 24

$workbook.Save()
$workbook.Close()
$excel.Quit()
[System.Runtime.Interopservices.Marshal]::ReleaseComObject($worksheet) | Out-Null
[System.Runtime.Interopservices.Marshal]::ReleaseComObject($workbook) | Out-Null
[System.Runtime.Interopservices.Marshal]::ReleaseComObject($excel) | Out-Null

$endTime = Get-Date
$timeTaken = ($endTime - $startTime).TotalMilliseconds / 1000
$formattedTimeTaken = "{0:N2}" -f $timeTaken

function Show-Notification {
    $title = "Scripts finished in $($formattedTimeTaken) seconds"
    $message = "You can now open _logs_finished.xlsx"
    $notification = New-Object -ComObject WScript.Shell
    $notification.Popup($message, 0, $title, 64)
}

Write-Host "`nSuccessfully formatted in _logs_finished.xlsx. You can close the window now..." -ForegroundColor Green -BackgroundColor Black
Show-Notification
$null = $host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")