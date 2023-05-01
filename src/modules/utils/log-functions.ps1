<#
Purpose:            Function that can takes any message, status and color for logging purposes.
Parameters:         message => The main content of the log.
                    status => Information for the user.
                    color => Color used for the status.
#>
function writeDefaultLog {

    param(
        [Parameter(Mandatory = $true)] [string] $message,
        [Parameter(Mandatory = $true)] [string] $status,
        [Parameter(Mandatory = $true)] [System.ConsoleColor] $color
    )

    $date = Get-Date

    Write-Host "[Execution status]" -ForegroundColor DarkGray -NoNewline
    Write-Host " - " -ForegroundColor White -NoNewline
    Write-Host "$date" -ForegroundColor Yellow -NoNewline
    Write-Host " - " -ForegroundColor White -NoNewline
    Write-Host "$status" -ForegroundColor $color
    Write-Host "[Execution message]" -ForegroundColor DarkGray -NoNewline
    Write-Host " - " -ForegroundColor White -NoNewline
    Write-Host "$message`n" -ForegroundColor White
}