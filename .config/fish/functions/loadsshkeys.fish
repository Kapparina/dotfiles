# Load all ssh keys that start with "id_rsa"
function loadsshkeys
  set added_keys (ssh-add -l)
   for key in (find ~/.ssh/ -not -name "*.pub" -a -iname "id_rsa*")
    if test ! (echo $added_keys | grep -o -e $key)
      ssh-add "$key"
    end
  end
end

# Call the function to run it.
loadsshkeys
