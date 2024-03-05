set -g fish_greeting

# Paths
# Find Git Bash
set -q GITBASH; or set -gx GITBASH (where sh)

# Variables
set -q PAGER; or set -gx PAGER "less"
set -q EDITOR; or set -gx EDITOR "nvim"

# Set browser on Windows
switch (uname -s)
    case MINGW64_NT-10.0-19045
        set -gx BROWSER open
end


if status is-interactive
    # Commands to run in interactive sessions can go here

    # Colorize man pages.
    set -q LESS_TERMCAP_mb; or set -gx LESS_TERMCAP_mb (set_color -o blue)
    set -q LESS_TERMCAP_md; or set -gx LESS_TERMCAP_md (set_color -o cyan)
    set -q LESS_TERMCAP_me; or set -gx LESS_TERMCAP_me (set_color normal)
    set -q LESS_TERMCAP_so; or set -gx LESS_TERMCAP_so (set_color -b white black)
    set -q LESS_TERMCAP_se; or set -gx LESS_TERMCAP_se (set_color normal)
    set -q LESS_TERMCAP_us; or set -gx LESS_TERMCAP_us (set_color -u magenta)
    set -q LESS_TERMCAP_ue; or set -gx LESS_TERMCAP_ue (set_color normal)

    echo "cd is for chumps! 💿 (zoxide)"
    zoxide init fish | source
    echo "Blasting off 🚀 (Starship)"
    starship init fish | source
    enable_transience
end

