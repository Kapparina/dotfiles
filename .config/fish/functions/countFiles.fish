# Count the number of files in the current directory
function countFiles
    command ls -1 | wc -l
end
