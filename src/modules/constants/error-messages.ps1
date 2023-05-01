# *********************************************************************************** #
#                                                                                     #
#     File that contains error messages throw during the execution of the script.     #
#                                                                                     #
# *********************************************************************************** #


[string]$global:error_empty_args = "The list of arguments passed with the command line execution is empty. You must provide at least 1 parameters with the command line execution."

[string]$global:error_environment_unknown = "The environment passed with the command line execution is not available. You must choose between one of these environments : local or beta."

[string]$global:error_config_read = "A configuration file named config.json is missing. You must add this file and then you can try to execute the script again."
[string]$global:error_config_empty = "The content of the configuration file is incorrect. This file can't be empty and it must contains at least the 'projects' property."