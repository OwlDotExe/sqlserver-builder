# *********************************************************************** #
#                                                                         #
#     Entry point of the script that contains all the logic execution     #
#                                                                         #
# *********************************************************************** #

. ".\src\modules\utils\log-functions.ps1"
. ".\src\modules\utils\constraint-functions.ps1"
. ".\src\modules\utils\file-functions.ps1"
. ".\src\modules\utils\treatment-functions.ps1"
. ".\src\modules\constants\colors.ps1"
. ".\src\modules\constants\statuses.ps1"
. ".\src\modules\constants\error-messages.ps1"
. ".\src\modules\constants\success-messages.ps1"


Clear-Host

# ***** Is command line arguments empty ***** #
if ($args.Count -eq 0) { 
    writeDefaultLog -message $error_empty_args -status $error_status -color $error_color
    exit
} else {
    writeDefaultLog -message $success_empty_args -status $success_status -color $success_color
}

# ***** Is environment passed in the list of existing environment ***** #
[bool]$result = isEnvironmentValid -environment $args[0]

if ($result -eq $false) {
    writeDefaultLog -message $error_environment_unknown -status $error_status -color $error_color
    exit
} else {
    writeDefaultLog -message $success_environment_known -status $success_status -color $success_color
}

# ***** Get the content of the configuration file ***** #
[PSCustomObject]$jsonObject = readConfigurationFile

# ***** Is projects property empty or not ***** #
if ($jsonObject.projects.Count -eq 0) {
    writeDefaultLog -message $error_projects_empty -status $error_status -color $error_color
} else {
    writeDefaultLog -message $success_project_filled -status $success_status -color $success_color
}

# ***** Complete checking of projects and credentials objects of the configuration file ***** #
checkConfiguration -jsonObject $jsonObject

# ***** Potential filtering action if the user has given arguments in the command line execution ***** #
[PSCustomObject[]]$projects = $jsonObject.projects

if ($args.Count -ge 2) {

    [Int32]$length = $args.Count - 1
    [string[]]$project_arguments = $args[1..$length]

    for ($i = 0; $i -lt $project_arguments.Length; $i++) {
        $project_arguments[$i] = $project_arguments[$i].ToLower()
    }

    $projects = filterProjects -projects $projects -arguments $project_arguments

    writeDefaultLog -message $success_project_filtering -status $success_status -color $success_color
}

# ***** Is SqlServer module installed ***** #
if (Get-Module -Name SqlServer -ListAvailable) {
    writeDefaultLog -message $success_module_installed -status $success_status -color $success_color
} else {
    Install-Module -Name SqlServer -Scope CurrentUser -Force -Verbose:$false -Confirm:$false -AllowClobber | Out-Null
    writeDefaultLog -message $success_module_installation -status $success_status -color $success_color
}

# ***** Regenerate database for every project ***** #
foreach ($project in $projects) {

    [PSCustomObject]$credential = getCredential -project $project -environment $args[0]

    [string]$instance_name = $project.instance_name
    [string]$complete_instance = "$env:computername\$instance_name"

    $ErrorActionPreference = "Stop"

    foreach ($path in $project.paths) {

        [string]$file = Split-Path $path -Leaf

        try {
            Invoke-Sqlcmd -InputFile $path -ServerInstance $complete_instance -Username $credential.user -Password $credential.password -TrustServerCertificate

            [string]$success_message = "The script $file has been executed successfully."

            writeDefaultLog -message $success_message -status $success_status -color $success_color
        }
        catch {
            [string]$error_message = "The execution of the script $file has been interrupted."

            writeDefaultLog -message $error_message -status $error_status -color $error_color
            Write-Host $_.Exception.Message -ForegroundColor Red
            exit
        }
    }
}