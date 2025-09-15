# Caching functions for bash startup optimization

_evalcache() {
  # Allow disabling cache via environment variable for profiling comparisons
  if [[ -n "${DISABLE_BASH_CACHE:-}" ]]; then
    "$@"
    return
  fi

  local cache_dir="${HOME}/.cache/dotfiles/bash"
  mkdir -p "$cache_dir"
   local cache_file="${cache_dir}/$(echo "$*" | md5sum | cut -d' ' -f1).sh"
  local deps=()
  # Add common deps if needed, but for now none
  local cache_valid=true
  for dep in "${deps[@]}"; do
    if [[ -f "$dep" && "$dep" -nt "$cache_file" ]]; then
      cache_valid=false
      break
    fi
  done
  if [[ ! -f "$cache_file" ]] || ! $cache_valid; then
    "$@" > "$cache_file"
  fi
  cat "$cache_file"
}

 _evalcache_clear() {
   rm -rf "${HOME}/.cache/dotfiles/bash"
 }