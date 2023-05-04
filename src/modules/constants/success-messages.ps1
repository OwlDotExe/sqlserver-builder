# ************************************************************************************* #
#                                                                                       #
#     File that contains success messages throw during the execution of the script.     #
#                                                                                       #
# ************************************************************************************* #


[string]$global:success_empty_args = "The list of arguments passed with the command line execution went through the empty check successfully."

[string]$global:success_environment_known = "The environment passed with the command line execution went through the environment check successfully.";

[string]$global:success_config_read = "The content of the configuration file (config.json) has been read successfully."
[string]$global:success_config_filled = "The configuration file went through content check successfully."

[string]$global:success_project_filled = "The 'projects' property went through empty check successfully.";

[string]$global:success_project_filtering = "Projects of the config.json file went through filtering process successfully."

[string]$global:success_module_installed = "The SqlServer module is already installed and there is no need to install it.";
[string]$global:success_module_installation = "The SqlServer module was missing and it has been installed successfully.";