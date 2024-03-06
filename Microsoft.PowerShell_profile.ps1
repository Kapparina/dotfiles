#Update OhMyPosh using this command -
# winget upgrade JanDeDobbeleer.OhMyPosh -s winget
#
# Typer-Cli completion.
# Installed via pip install typer-cli
# Dotfiles copy
$env:HOME_PROFILE = $false
$env:POSH_GIT_ENABLED = $true
$env:PDM_IGNORE_ACTIVE_VENV = $true

$dotfiles_dir = "$HOME\dotfiles"

$work_app_dir = "C:\Applications"
$work_scripts_dir = "$work_app_dir\PowerShell_start\scripts"


$powershell_dir = "$dotfiles_dir\powershell"
$powershell_scripts_dir = "$powershell_dir\scripts"
$powershell_completions = "$powershell_scripts_dir\completions\"

### START MAIN SCRIPT
Set-PSReadlineOption -BellStyle None
# BEGIN - Alias(s)
#Git aliases from Oh-my-zsh Git plugin for PWSH
Import-Module git-aliases -DisableNameChecking


$ChocolateyProfile = "$env:ChocolateyInstall\helpers\chocolateyProfile.psm1"
if (Test-Path($ChocolateyProfile))
{
    Import-Module "$ChocolateyProfile"
}
# END - Alias(s)


# BEGIN - Tooling Functions
function Test-CommandExists ([Parameter(Mandatory = $true)][string] $Command)
{
    return [bool](Get-Command $Command -ErrorAction SilentlyContinue)
}
# Work.sort of
function checkEnvironment
{
    if ($env:COMPUTERNAME -clike "*LG*")
    {
        return $true
    } else
    {
        return $false
    }
}
#
# Ensure safe creation of aliases, all aliases are created in the helpful_alias_creation.ps1
. "$powershell_scripts_dir\helpful_alias_creation.ps1"

# END - Tooling Functions

# Work
if (checkEnvironment)
{
    . "$work_scripts_dir\navigation_func_work.ps1"

    . "$work_scripts_dir\python_func_work.ps1"

    . "$work_scripts_dir\shell_alias_func_work.ps1"

}

# Not work/ AKA Home
if (-not (checkEnvironment))
{
    # Not required at work
    . "$powershell_scripts_dir\wsl_func_shell.ps1"

    . "$powershell_scripts_dir\navigation_func_home.ps1"

    . "$powershell_completions\completion_docker-compose.ps1"
}

#Raw Functions

function workconf
{
    if (-not ($args))
    {
        Start-Process $work_scripts_dir
    }
    if ( $args)
    {
        if ($args -eq "vim")
        {
            vim $work_scripts_dir
        }
        if ($args -eq "code")
        {
            code $work_scripts_dir
        }
    }
}

function Assert-IsNonInteractiveShell {
    # Test each Arg for match of abbreviated '-NonInteractive' command.
    $NonInteractive = [Environment]::GetCommandLineArgs() | Where-Object{ $_ -like '-NonI*' }

    if ([Environment]::UserInteractive -and -not $NonInteractive) {
        # We are in an interactive shell.
        return $false
    }

    return $true
}

if (!(Assert-IsNonInteractiveShell)) {
    Write-Host "Let's interact!"

    . "$powershell_scripts_dir\match_statement_tests.ps1"
    . "$powershell_completions\completion_general.ps1"
    . "$powershell_completions\completion_gh-cli.ps1"
    . "$powershell_completions\completion_az-cli.ps1"
    Invoke-Expression (&starship init powershell)
    Invoke-Expression (& { (zoxide init powershell | Out-String) })
}
