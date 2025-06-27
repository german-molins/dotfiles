#!/usr/bin/env sh

# Make mise available in the current shell.
PATH="$HOME/.local/bin:$PATH"

if ! command -v mise >/dev/null; then
    >&2 echo "[dotfiles][mise] ERROR: 'mise' command not found, skipping package installation"
    exit 1
fi

mise install
