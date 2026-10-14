for source_dir in ~/.local/share/chezmoi_*; do
    if [ -d "$source_dir" ]; then
        name=${source_dir##*/chezmoi_}
        alias "chezmoi-${name}"="chezmoi --source ${source_dir}"
    fi
done
