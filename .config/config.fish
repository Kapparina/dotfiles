if status is-interactive
    # Commands to run in interactive sessions can go here
end

# Clear and list contents with detailed information
function ca
    clear
    ls -lah
end

# Count the number of files in the current directory
function countFiles
    ls -1 | wc -l
end

# List contents with detailed information
alias ll="ls -lah"

# List contents with color coding and file type indicators
alias ls="ls -F -1 --color=auto --show-control-chars"

# Source config after changes
alias spro="source ~/.config/fish/config.fish"

# Custom cd + ls function
function cdls
    if test -z $argv
        echo "Usage: cdls <directory>"
        return 1
    end

    if test -d $argv[1]
        cd $argv[1]
    else
        echo "Directory not found: $argv[1]"
        return 1
    end

    ls
end 

# Edit config.fish
function confish
    nvim "~/.config/fish/config.fish"
end

# Equivalent to cdls but with zoxide
function zl
    if test -z $argv
        echo "Usage: zl <directory>"
        return 1
    end

    z $argv[1]

    ls
end

starship init fish | source
zoxide init fish | source
