$currentPSModulePath = $env:PSModulePath
$workDefaultPSModulePath = "C:\Applications\PowerShell_start\Modules"
$env:PSModulePath = [NullString]
$env:PYTHON_PATH = [NullString]
$env:YAZI_CONFIG_HOME = "$HOME\.config\yazi"
$env:XDG_CONFIG_HOME = "$HOME\.config"
$documentsPath = [Environment]::GetFolderPath("MyDocuments")
Invoke-Expression (& { (zoxide init powershell | Out-String) })

# Invoke-Expression (&starship init powershell)

$LazyLoadProfile = [PowerShell]::Create()
[void]$LazyLoadProfile.AddScript(@'
    Import-Module PSReadLine
    Import-Module -Name CompletionPredictor
'@)


$LazyLoadProfileRunspace = [RunspaceFactory]::CreateRunspace()
$LazyLoadProfile.Runspace = $LazyLoadProfileRunspace
$LazyLoadProfileRunspace.Open()
[void]$LazyLoadProfile.BeginInvoke()

$null = Register-ObjectEvent -InputObject $LazyLoadProfile -EventName InvocationStateChanged -Action {
    $env:PYTHONIOENCODING='utf-8' 
    iex "$(thefuck --alias)"
    Import-Module PSReadLine
    Import-Module -Name CompletionPredictor
    $global:GitPromptSettings.DefaultPromptPrefix.Text = '$(Get-Date -f "MM-dd HH:mm:ss") '
    $global:GitPromptSettings.DefaultPromptPrefix.ForegroundColor = [ConsoleColor]::Magenta
    $global:GitPromptSettings.DefaultPromptBeforeSuffix.Text = '`n'
    $global:GitPromptSettings.DefaultPromptAfterSuffix.Text = ''

    $LazyLoadProfile.Dispose()
    $LazyLoadProfileRunspace.Close()
    $LazyLoadProfileRunspace.Dispose()
}

# Dotfiles copy
$env:HOME_PROFILE = $false
$env:PDM_IGNORE_ACTIVE_VENV = $true

$dotfiles_dir = "$HOME\dotfiles"

$powershell_dir = "$dotfiles_dir\powershell"
$powershell_scripts_dir = "$powershell_dir\scripts"

$env:EDITOR = $env:VISUAL = 'nvim'

function e ([Parameter(Mandatory = $false)][String] $target)
{
    $replace_hashmap = @{
            "C:" = "/mnt/c"
            "\\" = "/"
    }
    $unix_target = $target

    foreach ($item in $replace_hashmap.GetEnumerator())
    {
        $unix_target = $unix_target -replace $item.Key, $item.Value
    }
    wsl -- nvim "$unix_target"
}

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
        $env:HOME_PROFILE = $false
        return $true
    } else
    {
        return $false
    }
}

# Ensure safe creation of aliases, all aliases are created in the helpful_alias_creation.ps1
. "$powershell_scripts_dir\helpful_alias_creation.ps1"

# END - Tooling Functions

# Work
if (checkEnvironment -eq $true)
{
    $env:PSModulePath = $workDefaultPSModulePath
        . "$powershell_scripts_dir\work_scripts.ps1"
}


# Not work/ AKA Home
if (-not (checkEnvironment))
{
    $env:PSModulePath = $currentPSModulePath
    Invoke-Expression (& { (zoxide init powershell | Out-String) })
    . "$powershell_scripts_dir\home_scripts.ps1"
}

. "$powershell_scripts_dir\general_scripts.ps1"

$catppuccinModulePath = "$(($env:PSModulePath -split ";")[0])\Catppuccin"
if (-not (Test-Path -Path "$catppuccinModulePath"))
{
    & git clone "https://github.com/catppuccin/powershell" "$catppuccinModulePath"
    if ($LASTEXITCODE -ne 0) 
    {
        Write-Host "Catppuccin setup failed: $error[0]"
    }
}

Import-Module Catppuccin
# $Flavor = $Catppuccin['Latte']
$Flavor = $Catppuccin['Mocha']
function prompt {
    $(if (Test-Path variable:/PSDebugContext) { "$($Flavor.Red.Foreground())[DBG]: " }
            else { '' }) + "$($Flavor.Teal.Foreground())PS $($Flavor.Yellow.Foreground())" + $(Get-Location) +
        "$($Flavor.Green.Foreground())" + $(if ($NestedPromptLevel -ge 1) { '>>' }) + '> ' + $($PSStyle.Reset)
}

# The following colors are used by PowerShell's formatting
# Again PS 7.2+ only
$PSStyle.Formatting.Debug = $Flavor.Sky.Foreground()
$PSStyle.Formatting.Error = $Flavor.Red.Foreground()
$PSStyle.Formatting.ErrorAccent = $Flavor.Blue.Foreground()
$PSStyle.Formatting.FormatAccent = $Flavor.Teal.Foreground()
$PSStyle.Formatting.TableHeader = $Flavor.Rosewater.Foreground()
$PSStyle.Formatting.Verbose = $Flavor.Yellow.Foreground()
$PSStyle.Formatting.Warning = $Flavor.Peach.Foreground()

$Colors = @{
# Largely based on the Code Editor style guide
# Emphasis, ListPrediction and ListPredictionSelected are inspired by the Catppuccin fzf theme
    
# Powershell colours
        ContinuationPrompt     = $Flavor.Teal.Foreground()
        Emphasis               = $Flavor.Red.Foreground()
        Selection              = $Flavor.Surface0.Background()
        
# PSReadLine prediction colours
        InlinePrediction       = $Flavor.Overlay0.Foreground()
        ListPrediction         = $Flavor.Mauve.Foreground()
        ListPredictionSelected = $Flavor.Surface0.Background()
        
# Syntax highlighting
        Command                = $Flavor.Blue.Foreground()
        Comment                = $Flavor.Overlay0.Foreground()
        Default                = $Flavor.Text.Foreground()
        Error                  = $Flavor.Red.Foreground()
        Keyword                = $Flavor.Mauve.Foreground()
        Member                 = $Flavor.Rosewater.Foreground()
        Number                 = $Flavor.Peach.Foreground()
        Operator               = $Flavor.Sky.Foreground()
        Parameter              = $Flavor.Pink.Foreground()
        String                 = $Flavor.Green.Foreground()
        Type                   = $Flavor.Yellow.Foreground()
        Variable               = $Flavor.Lavender.Foreground()
}

# Set the colours
Set-PSReadLineOption -Colors $Colors

# Modified from the official Catppuccin fzf configuration at: https://github.com/catppuccin/fzf/
$ENV:FZF_DEFAULT_OPTS = @"
--color=bg+:$($Flavor.Surface0),bg:$($Flavor.Base),spinner:$($Flavor.Rosewater)
--color=hl:$($Flavor.Red),fg:$($Flavor.Text),header:$($Flavor.Red)
--color=info:$($Flavor.Mauve),pointer:$($Flavor.Rosewater),marker:$($Flavor.Rosewater)
--color=fg+:$($Flavor.Text),prompt:$($Flavor.Mauve),hl+:$($Flavor.Red)
--color=border:$($Flavor.Surface2)
"@

function .
{
    Start-Process .
}

function yy
{
    $tmp = [System.IO.Path]::GetTempFileName()
        yazi $args --cwd-file="$tmp"
        $cwd = Get-Content -Path $tmp
        if (-not [String]::IsNullOrEmpty($cwd) -and $cwd -ne $PWD.Path) {
            Set-Location -LiteralPath $cwd
        }
    Remove-Item -Path $tmp
}

function la
{
    param ($path = ".")
    Get-ChildItem $path -Force
}

function l
{
    param ($path = ".")
    Get-ChildItem $path -Force
    # [System.IO.Directory]::GetFiles($path) -Force
}

function rbl([Parameter(Mandatory=$true, Position=0)][Object] $MachineNumbers)
{
    if ($MachineNumbers.GetType().Equals([Object[]]))
    {
        $MachineNumbers = [String]::Join(",", $MachineNumbers)
    }    
    & "C:\Users\schneet\OneDrive - Link Group\Documents\PowerShell\Scripts\AutomateBat.ps1" $MachineNumbers
}


function rb([Parameter(Mandatory=$true, Position=0)][Object] $MachineNumbers)
{
    if ($MachineNumbers.GetType().Equals([Object[]]))
    {
        $MachineNumbers = [String]::Join(",", $MachineNumbers)
    }    
    & "C:\Users\schneet\OneDrive - Link Group\Documents\PowerShell\Scripts\RestartVM.ps1" $MachineNumbers
}


Get-ChildItem "$powershell_scripts_dir\completions" | ForEach-Object {
    . $_.FullName
}

function gt() {
    git describe --abbrev=0
}
