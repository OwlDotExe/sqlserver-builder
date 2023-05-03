# --> Refactor of module sourcing.
# --> Check configuration file content.
# --> Check for environment mode => yes => success no => error.
# --> Assign the right list of projects to be treated => all if nothing or just projects passed.
# --> Check projects names if it's a custom call for the command.
# --> Singleton class for database connection.
# --> Execute all the script.


# *********************************************************************** #
#                                                                         #
#     Entry point of the script that contains all the logic execution     #
#                                                                         #
# *********************************************************************** #

. ".\src\modules\utils\log-functions.ps1"
. ".\src\modules\utils\constraint-functions.ps1"
. ".\src\modules\utils\file-functions.ps1"
. ".\src\modules\constants\colors.ps1"
. ".\src\modules\constants\statuses.ps1"
. ".\src\modules\constants\error-messages.ps1"
. ".\src\modules\constants\success-messages.ps1"


Clear-Host

# ***** --> Is command line arguments empty ***** #
if ($args.Count -eq 0) { 
    writeDefaultLog -message $error_empty_args -status $error_status -color $error_color
    exit
} else {
    writeDefaultLog -message $success_empty_args -status $success_status -color $success_color
}

# ***** --> Is environment passed in the list of existing environment ***** #
[bool]$result = isEnvironmentValid -environment $args[0]

if ($result -eq $false) {
    writeDefaultLog -message $error_environment_unknown -status $error_status -color $error_color
    exit
} else {
    writeDefaultLog -message $success_environment_known -status $success_status -color $success_color
}

# ***** Get the content of the configuration file ***** #
[PSCustomObject]$jsonObject = readConfigurationFile

# ***** --> Is projects property empty or not ***** #
if ($jsonObject.projects.Count -eq 0) {
    writeDefaultLog -message $error_projects_empty -status $error_status -color $error_color
} else {
    writeDefaultLog -message $success_project_filled -status $success_status -color $success_color
}

# ***** --> Complete checking of projects and credentials objects of the configuration file ***** #
checkConfiguration -jsonObject $jsonObject