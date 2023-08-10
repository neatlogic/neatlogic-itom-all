exclude_dirs=$(cat exclude_dirs.txt)

for i in $(find . -name "neatlogic*" -maxdepth 1 -type d); do
    if ! echo "${exclude_dirs}" | grep -q "^${i}$"; then
        cd "$i"
        echo $i
        git pushgitee
        git pushgithub
        cd ..
    fi
done