export ASDF_CONFIG_FILE="$HOME/.config/asdf/.asdfrc"
export ASDF_DATA_DIR="$HOME/.local/share/asdf"
export PATH="$ASDF_DATA_DIR/shims:$PATH"

. <(asdf completion bash)
