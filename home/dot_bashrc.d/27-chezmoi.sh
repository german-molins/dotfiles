eval "$(chezmoi completion bash)"

# Creates aliases for additional chezmoi source directories
# For each directory matching ~/.local/share/chezmoi_*, creates
# an alias chezmoi-name that uses that directory as source
# Example: ~/.local/share/chezmoi_work creates alias chezmoi-work
for source_dir in ~/.local/share/chezmoi_*; do
    if [ -d "$source_dir" ]; then
        name=${source_dir##*/chezmoi_}
        alias "chezmoi-${name}"="chezmoi --source ${source_dir}"
    fi
done
