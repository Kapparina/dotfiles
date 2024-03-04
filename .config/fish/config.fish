set -g fish_greeting

if status is-interactive
    # Commands to run in interactive sessions can go here
    echo "cd is for chumps! (zoxide)"
    zoxide init fish | source
    echo "Blasting off... (Starship)"
    starship init fish | source
end

