#!/bin/sh

# [dotfiles][install] This script installs chezmoi and initializes it with the
# dotfiles repository. It checks if chezmoi is installed, installs it if not,
# and then initializes chezmoi with the current script directory as the source.
# If the current directory is not the default chezmoi source directory, it moves
# the repository to the default directory.

set -eu

echo "[dotfiles][install] Starting installation script."

if [ ! "$(command -v chezmoi)" ]; then
  bin_dir="$HOME/.local/bin"
  chezmoi="$bin_dir/chezmoi"
  echo "[dotfiles][install] Installing chezmoi to '${chezmoi}'." >&2
  if command -v curl >/dev/null; then
    chezmoi_install_script="$(curl -fsSL get.chezmoi.io)"
  elif command -v wget >/dev/null; then
    chezmoi_install_script="$(wget -qO- get.chezmoi.io)"
  else
    echo "[dotfiles][install] To install chezmoi, you must have curl or wget installed." >&2
    exit 1
  fi
  sh -c "${chezmoi_install_script}" -- -b "${bin_dir}"
  unset chezmoi_install_script bin_dir
fi

# POSIX way to get script's dir: https://stackoverflow.com/a/29834779/12156188
script_dir="$(cd -P -- "$(dirname -- "$(command -v -- "$0")")" && pwd -P)"
echo "[dotfiles][install] Initializing chezmoi with source directory '$script_dir'"

set -- init --apply --source="${script_dir}"
echo "[dotfiles][install] Running 'chezmoi $*'" >&2
exec "$chezmoi" "$@"
