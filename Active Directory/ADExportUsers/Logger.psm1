$logDirectory = ".\logs"
$logFile = $logDirectory + "\ProcessTermination_$(get-date -f MM-dd-yyyy).log"
function WriteLog {
    param (
        [string]$Message,
        [string]$LogLevel = "INFO",
        [switch]$PurgeLogs
    )

    if ($PurgeLogs) {
        Get-ChildItem -Path $logDirectory -Filter *.log | Where-Object {
            $_.LastWriteTime -lt (Get-Date).AddDays(-30)
        } | Remove-Item -Force
    }

    if (!(Test-Path -PathType Container $logDirectory)) {
        New-Item -ItemType Directory -Path $logDirectory
    }

    $logEntry = "[{0}]{1}{2}" -f (get-date -f 'MM/dd/yyyy HH:mm:ss'), "[$loglevel]", $message
    $logEntry | Out-File -Append -FilePath $logFile
    Write-Host $logEntry
}