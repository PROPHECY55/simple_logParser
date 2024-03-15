$logPathFile = Join-Path -Path $PSScriptRoot -ChildPath "..\logPath.txt"
$folderPath = Get-Content $logPathFile

$logFiles = Get-ChildItem -Path $folderPath -Filter "*.log" -File

$currentDirectory = Split-Path -Parent $MyInvocation.MyCommand.Path
$logsFolderPath = Join-Path $currentDirectory "..\logs"
$txtFilePath = Join-Path $logsFolderPath "log_filenames.txt"
$names = $logFiles | ForEach-Object { $_.Name -replace '\.log$' }
$names | Set-Content -Path $txtFilePath