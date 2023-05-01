$global:environments = @('local', 'beta')

<#
Purpose:            Function that verifies the integrity of the environment passed.
Parameters:         environment => The development environment.
Return:             Boolean that represents the integrity of the environment.
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