. ".\src\modules\utils\log-functions.ps1"
. ".\src\modules\constants\colors.ps1"
. ".\src\modules\constants\statuses.ps1"
. ".\src\modules\constants\error-messages.ps1"
. ".\src\modules\constants\success-messages.ps1"


<#
Purpose:            Function that reads the content of the configuration file.
Parameters:         Ø
Return:             JSON object.
#>
function readConfigurationFile {

    try {
        [string]$content = Get-Content -Path ".\config.json" -Raw -ErrorAction Stop

        writeDefaultLog -message $success_config_read -status $success_status -color $success_color

        if ([string]::IsNullOrWhitespace($content) -or $content.Contains("projects") -eq $false) {
            writeDefaultLog -message $error_config_empty -status $error_status -color $error_color
            exit
        }

        writeDefaultLog -message $success_config_filled -status $success_status -color $success_color

        return $content | ConvertFrom-Json
    }
    catch {
        writeDefaultLog -message $error_config_read -status $error_status -color $error_color
        exit
    }
}