<#
Purpose:            Function that filters the project to treat based on user request.
Parameters:         projects => The list of project that are available.
                    arguments => The requested project by the user.
Return:             Ø
#>
function filterProjects {

    param(
        [Parameter(Mandatory = $true)] [PSCustomObject[]] $projects,
        [Parameter(Mandatory = $true)] [string[]] $arguments
    )

    [PSCustomObject]$projects_treated = @()
    [string]$error_message = ""

    foreach ($argument in $arguments) {

        [PSCustomObject[]]$matching_objects = $projects | Where-Object { $_.name.ToLower() -eq $argument }
    
        if ($matching_objects.Count -eq 0) {
            $error_message = "No project has been found for the '$argument' argument. Please make sure that your project exists in the config.json file."

            writeDefaultLog -message $error_message -status $error_status -color $error_color
            exit
        }

        if ($matching_objects.Count -ge 2) {
            $error_message = "Multiple projects have been found for the '$argument' argument. Please make sure there is no duplicated entries in your configuration file."

            writeDefaultLog -message $error_message -status $error_status -color $error_color
            exit
        }

        $projects_treated += $matching_objects[0]
    }

    return $projects_treated
}

<#
Purpose:            Function that get the credential object that matches the environment requested by the user.
Parameters:         project => The object that contains all the available credentials.
                    environment => The environment requested by the user.
Return:             Ø
#>
function getCredential {

    param(
        [Parameter(Mandatory = $true)] [PSCustomObject] $project,
        [Parameter(Mandatory = $true)] [string] $environment
    )

    [PSCustomObject]$matching_credentials = @()
    [string]$error_message = ""

    [PSCustomObject[]]$matching_objects = $project.credentials | Where-Object { $_.environment.ToLower() -eq $environment.ToLower() }

    [string]$name = $project.name

    if ($matching_objects.Count -eq 0) {
        $error_message = "No credential has been found for the '$environment' environment. Please make sure that project ($name) does have a credential that contains the requested environment."

        writeDefaultLog -message $error_message -status $error_status -color $error_color
        exit
    }

    if ($matching_objects.Count -ge 2) {
        $error_message = "Multiple credentials have been found for the '$environment' environment. Please make sure there is no duplicated entries for the credentials of project ($name)."

        writeDefaultLog -message $error_message -status $error_status -color $error_color
        exit
    }

    return $matching_objects[0]
}