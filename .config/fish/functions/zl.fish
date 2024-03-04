# Equivalent to cdls but with zoxide
function zl
    if test -z $argv
        echo "Usage: zl <directory>"
        return 1
    end

    z $argv[1]

    ls
end
