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
