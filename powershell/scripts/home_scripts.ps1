$powershell_dir = "$dotfiles_dir\powershell"
$powershell_scripts_dir = "$powershell_dir\scripts"
$powershell_completions = "$powershell_scripts_dir\completions\"

# Not required at work
. "$powershell_scripts_dir\wsl_func_shell.ps1"

. "$powershell_scripts_dir\navigation_func_home.ps1"

. "$powershell_completions\completion_docker-compose.ps1"

Import-Module git-aliases -DisableNameChecking
Import-Module posh-cargo
Import-Module DockerCompletion
Import-Module PSReadLine
# Import-Module -Name CompletionPredictor
