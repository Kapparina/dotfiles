function mgr
    if set -q PROJECTS
        cdls $PROJECTS
    else
        echo "PROJECTS variable not set"
    end
end
