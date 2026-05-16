# Get-JoinTimeline.ps1
# Collects recent Task Scheduler and Device Registration events
# Useful for analyzing Hybrid Azure AD Join timing and behavior
#
# Note: This script does not collect user data or credentials.

# Create output folder if needed
$outputFolder = "C:\Temp"
if (!(Test-Path $outputFolder)) {
    New-Item -ItemType Directory -Path $outputFolder | Out-Null
}

# Timestamp
$timestamp = Get-Date -Format "yyyyMMdd_HHmmss"
$outputPath = "$outputFolder\DeviceJoinLogs_$timestamp.csv"

# Limit to last 2 hours (adjust if needed)
$startTime = (Get-Date).AddHours(-2)

# Get Task Scheduler events (filtered + limited)
$taskEvents = Get-WinEvent -FilterHashtable @{
    LogName = "Microsoft-Windows-TaskScheduler/Operational"
    StartTime = $startTime
} | Where-Object {
    $_.Message -like "*Automatic-Device-Join*" -and
    ($_.Id -in 100,102,325)
} | Select-Object TimeCreated, Id, LevelDisplayName,
    @{Name="Source"; Expression={"TaskScheduler"}},
    Message

# Get Device Registration events (filtered)
$joinEvents = Get-WinEvent -FilterHashtable @{
    LogName = "Microsoft-Windows-User Device Registration/Admin"
    StartTime = $startTime
} | Select-Object TimeCreated, Id, LevelDisplayName,
    @{Name="Source"; Expression={"UserDeviceRegistration"}},
    Message

# Combine + sort
$combined = $taskEvents + $joinEvents | Sort-Object TimeCreated

# Export
$combined | Export-Csv -Path $outputPath -NoTypeInformation

Write-Host ""
Write-Host "✅ Log export completed:"
Write-Host $outputPath -ForegroundColor Green
Write-Host ""
Write-Host "===================================" -ForegroundColor DarkGray
Write-Host "Log export completed successfully" -ForegroundColor Green
Write-Host "File location:" -ForegroundColor Yellow
Write-Host $outputPath -ForegroundColor Cyan
Write-Host "===================================" -ForegroundColor DarkGray