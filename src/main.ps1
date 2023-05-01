# --> Params ? yes => read configuration file and cast it as an object.
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

. "$PSScriptRoot\modules\utils\log-functions.ps1"
. "$PSScriptRoot\modules\utils\constraint-functions.ps1"

# ***** Global variables defined at the begining of the script ***** //
[string]$global:error_status = "error"
[string]$global:success_status = "success"

[System.ConsoleColor]$global:error_color = [System.ConsoleColor]::Red
[System.ConsoleColor]$global:success_color = [System.ConsoleColor]::Green

[string]$global:error_empty_args = "The list of arguments passed with the command line execution is empty. You must provide at least 1 parameters with the command line execution."
[string]$global:error_environment_unknown = "The environment passed with the command line execution is not available. You must choose between one of these environments : local or beta."

[string]$global:success_empty_args = "The list of arguments passed with the command line execution went through the empty check successfully."
[string]$global:success_environment_known = "The environment passed with the command line execution went through the environment check successfully.";

Clear-Host

# ***** First check --> Is command line arguments empty ***** //
if ($args.Count -eq 0) { 
    writeDefaultLog -message $error_empty_args -status $error_status -color $error_color
    exit
} else {
    writeDefaultLog -message $success_empty_args -status $success_status -color $success_color
}

# ***** Second check --> Is environment passed in the list of existing environment ***** #
[bool]$result = isEnvironmentValid -environment $args[0]

if ($result -eq $false) {
    writeDefaultLog -message $error_environment_unknown -status $error_status -color $error_color
    exit
} else {
    writeDefaultLog -message $success_environment_known -status $success_status -color $success_color
}