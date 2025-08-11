for util in $(coreutils --list); do
    eval "alias $util='coreutils $util'"
done
