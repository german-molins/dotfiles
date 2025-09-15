 hash -p ~/.local/bin/mise mise

 _mise_evalcache() {
   local cache_dir="${HOME}/.cache/dotfiles/bash/mise"
   mkdir -p "$cache_dir"
   local cache_file="${cache_dir}/activate_bash.sh"
   local deps=("$HOME/.local/bin/mise")
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

 _mise_evalcache_hook() {
   local cache_dir="${HOME}/.cache/dotfiles/bash/hooks"
   mkdir -p "$cache_dir"
   local key=$(echo "$* $(pwd)" | md5sum | cut -d' ' -f1)
   local cache_file="${cache_dir}/${key}.sh"
   local deps=("$HOME/.local/bin/mise")
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

 _mise_evalcache_clear() {
   rm -rf "${HOME}/.cache/dotfiles/bash/mise" "${HOME}/.cache/dotfiles/bash/hooks"
 }

 eval "$(_mise_evalcache mise activate bash)"
 eval "$(mise completion bash --include-bash-completion-lib)"

 _mise_hook() {
   local previous_exit_status=$?;
   eval "$(_mise_evalcache_hook mise hook-env -s bash)";
   return $previous_exit_status;
 }
