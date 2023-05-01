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

# ***** Global variables defined at the begining of the script ***** //
$global:error_status = "error"
$global:success_status = "success"

$global:error_color = [System.ConsoleColor]::Red
$global:success_color = [System.ConsoleColor]::Green

$global:error_empty_args = "The list of arguments passed with the command line execution is empty. You must provide at least 1 parameters with the command line execution."

$global:success_empty_args = "The list of arguments passed with the command line execution went through the empty check successfully."

Clear-Host

# ***** First check --> Is command line arguments empty ***** //
if ($args.Count -eq 0) { 
    writeDefaultLog -message $error_empty_args -status $error_status -color $error_color
} else {
    writeDefaultLog -message $success_empty_args -status $success_status -color $success_color
}