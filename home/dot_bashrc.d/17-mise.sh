export PATH="~/.local/bin:$PATH"

if command -v mise >/dev/null 2>&1; then
    eval "$(mise activate bash)"
    eval "$(mise completion bash --include-bash-completion-lib)"
fi
