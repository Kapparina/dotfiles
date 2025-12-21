Invoke-Expression (zoxide init powershell | Out-String)

$dotfiles_dir = "$env:HOMEPATH/dotfiles"
$my_prof = "$dotfiles_dir\powershell\Microsoft.PowerShell_profile.ps1"

$PYTHON_PATH = "$HOME\scoop\apps\python\current\python.exe"
$env:PYTHON_PATH = "$HOME\scoop\apps\python\current\python.exe"

function myProfile
{
    Write-Host "Reading profile"
    $res =  [System.IO.File]::ReadAllTextAsync($my_prof).Result.ToString()
    return $res
}

Write-Host "Invoking profile"
myProfile | Invoke-Expression
