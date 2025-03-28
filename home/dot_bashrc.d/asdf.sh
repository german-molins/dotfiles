export ASDF_DATA_DIR="$HOME/.local/share/asdf"
export PATH="${ASDF_DATA_DIR:-$HOME/.asdf}/shims:$PATH"

. <(asdf completion bash)
