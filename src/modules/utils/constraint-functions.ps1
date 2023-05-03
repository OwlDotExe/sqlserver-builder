. ".\src\modules\utils\log-functions.ps1"
. ".\src\modules\constants\colors.ps1"
. ".\src\modules\constants\statuses.ps1"

$global:environments = @('local', 'beta')

<#
Purpose:            Function that verifies the integrity of an environment passed.
Parameters:         environment => A development environment.
Return:             Boolean that represents the integrity of an environment.
#>
function isEnvironmentValid {

    param(
        [Parameter(Mandatory = $true)] [string] $environment
    )

    if ($environments -contains $environment) {
        return $true;
    }
    return $false;
}

<#
Purpose:            Function that verifies the integrity of the configuration file's content.
Parameters:         jsonObject => Object converted when the script read the config file.
Return:             Ø
#>
function checkConfiguration {

    param(
        [Parameter(Mandatory = $true)] [PSCustomObject] $jsonObject
    )

    for ($i = 0; $i -lt $jsonObject.projects.Count; $i++) {

        [PSCustomObject]$project = $jsonObject.projects[$i]
        [Int32]$number = $i + 1

        isProjectValid -project $project -index $number

        [string]$error_message = "'Paths' property of project number $number is empty. Please make sure to put at least one file path in your config.json file."
        [string]$success_message = "'Paths' property of project number $number went through empty check successfully."
    
        if ($project.paths.Count -eq 0) {
            writeDefaultLog -message $error_message -status $error_status -color $error_color
            exit
        } else {
            writeDefaultLog -message $success_message -status $success_status -color $success_color
        }

        arePathsValid -paths $project.paths -index $number

        $error_message = "'Credentials' property of project number $number is empty. Please make sure to put at least one credential object in your config.json file."
        $success_message = "'Credentials' property of project number $number went through empty check successfully."

        if ($project.credentials.Count -eq 0) {
            writeDefaultLog -message $error_message -status $error_status -color $error_color
            exit
        } else {
            writeDefaultLog -message $success_message -status $success_status -color $success_color
        }

        areCredentialsValid -credentials $project.credentials -index $number
    }
}

<#
Purpose:            Function that verifies the integrity of a project object.
Parameters:         project => An object that has to be verified.
                    index => The index of the project that is beeing verified.
Return:             Boolean that represents the integrity of a project.
#>
function isProjectValid {

    param(
        [Parameter(Mandatory = $true)] [PSCustomObject] $project,
        [Parameter(Mandatory = $true)] [Int32] $index
    )

    [bool]$is_name_empty = [string]::IsNullOrWhitespace($project.name)
    [bool]$is_instance_empty = [string]::IsNullOrWhitespace($project.instance_name)
    [bool]$is_database_empty = [string]::IsNullOrWhitespace($project.database_name)

    [string]$success_message = "Properties of project number $index in the config.json file went trough empty check successfully."
    [string]$error_message = "One or multiple properties of project number $index in the config.json file are empty. Please make sure to replace empty strings by your personal values."

    if ($is_name_empty -eq $true -or $is_instance_empty -eq $true -or $is_database_empty -eq $true) {
        writeDefaultLog -message $error_message -status $error_status -color $error_color
        exit
    } else {
        writeDefaultLog -message $success_message -status $success_status -color $success_color
    }
}

<#
Purpose:            Function that verifies the integrity of a list of script paths.
Parameters:         paths => An array of paths.
                    index => The index of the project that is beeing verified.
Return:             Boolean that represents the integrity of a list of script paths.
#>
function arePathsValid {

    param(
        [Parameter(Mandatory = $true)] [string[]] $paths,
        [Parameter(Mandatory = $true)] [Int32] $index
    )

    foreach ($path in $paths) {

        $success_message = "The path ($path) of project number $index went through path checking successfully."
        $error_message = "The path ($path) of project number $index is not recognized. Please make sure this file path is existing on your computer."

        if (Test-Path $path) {
            writeDefaultLog -message $success_message -status $success_status -color $success_color
        } else {
            writeDefaultLog -message $error_message -status $error_status -color $error_color
            exit
        }
    }
}

<#
Purpose:            Function that verifies the integrity of a list of credential objects.
Parameters:         credentials => An array of credential objects.
                    index => The index of the project that is beeing verified.
Return:             Boolean that represents the integrity of a list of credential objects.
#>
function areCredentialsValid {

    param(
        [Parameter(Mandatory = $true)] [PSCustomObject] $credentials,
        [Parameter(Mandatory = $true)] [Int32] $index
    )

    foreach ($credential in $credentials) {

        [bool]$result = isEnvironmentValid -environment $credential.environment
        [string]$success_message = "The 'environment' property of credential number $index of project number $index went through the environment check successfully."
        [string]$error_message = "The 'enviroment' property of credential number $index of project number $index is not available. You must choose between one of these environments : local or beta."

        if ($result -eq $false) {
            writeDefaultLog -message $error_message -status $error_status -color $error_color
            exit
        } else {
            writeDefaultLog -message $success_message -status $success_status -color $success_color
        }

        [bool]$is_user_empty = [string]::IsNullOrWhitespace($credential.user)
        [bool]$is_password_empty = [string]::IsNullOrWhitespace($credential.password)

        $error_message = "One or multiple properties of credential number $index of project number $index in the config.json file are empty. Please make sure to replace empty strings by your personal values."
        $success_message = "Properties of credential number $index of project number $index in the config.json file went trough empty check successfully."

        if ($is_user_empty -eq $true -or $is_password_empty -eq $true) {
            writeDefaultLog -message $error_message -status $error_status -color $error_color
            exit
        } else {
            writeDefaultLog -message $success_message -status $success_status -color $success_color
        }
    }
}