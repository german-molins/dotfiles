export PATH="~/.local/bin:$PATH"

_mise_evalcache()
{
    # Allow disabling cache via environment variable for profiling comparisons
    if [[ -n "${DISABLE_BASH_CACHE:-}" ]]; then
        "$@"
        return
    fi

    local cache_dir="${HOME}/.cache/dotfiles/bash/mise"
    mkdir -p "$cache_dir"
    local cache_file="${cache_dir}/activate_bash.sh"
    local deps=("$HOME/.local/bin/mise" "$HOME/.local/share/mise/installs")
    local cache_valid=true
    for dep in "${deps[@]}"; do
        if [[ -e "$dep" && "$dep" -nt "$cache_file" ]]; then
            cache_valid=false
            break
        fi
    done
    if [[ ! -f "$cache_file" ]] || ! $cache_valid; then
        [[ "${DOTFILES_VERBOSE:-}" == "true" ]] && echo "[mise-evalcache] Refreshing cache for command '$*'" >&2
        rm -f "$cache_file"
        if "$@" >"$cache_file" 2>/dev/null && [[ -s "$cache_file" ]]; then
            # Command succeeded and produced output
            :
        else
            # Command failed or produced no output, create empty cache
            : >"$cache_file"
        fi
    fi
    [[ -f "$cache_file" ]] && cat "$cache_file"
}

_mise_evalcache_clear()
{
    rm -rf "${HOME}/.cache/dotfiles/bash/mise" "${HOME}/.cache/dotfiles/bash/hooks"
}

# Only activate mise if the binary exists
if command -v mise >/dev/null 2>&1; then
    eval "$(_mise_evalcache mise activate bash)"
    eval "$(mise completion bash --include-bash-completion-lib)"
fi
