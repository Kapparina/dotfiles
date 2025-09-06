# BEGIN - Vim things
$dotfiles_dir = "$HOME\dotfiles"
$dotfiles_config = "$dotfiles_dir\.config"

$nvim_main_dir = "$dotfiles_config"

function vim
{
    $env:XDG_CONFIG_HOME = "$nvim_main_dir"
    $env:NVIM_APPNAME = "nvim"
    nvim $args
}

# END - Vim things
