#!/bin/sh

# [dotfiles][install] This script installs chezmoi and initializes it with the
# dotfiles repository. It checks if chezmoi is installed, installs it if not,
# and then initializes chezmoi with the current script directory as the source.
# If the current directory is not the default chezmoi source directory, it moves
# the repository to the default directory.

set -e # -e: exit on error

echo "[dotfiles][install] Starting installation script."

if [ ! "$(command -v chezmoi)" ]; then
  bin_dir="$HOME/.local/bin"
  chezmoi="$bin_dir/chezmoi"
  if [ "$(command -v curl)" ]; then
    echo "[dotfiles][install] Installing chezmoi using curl."
    sh -c "$(curl -fsSL https://git.io/chezmoi)" -- -b "$bin_dir"
  elif [ "$(command -v wget)" ]; then
    echo "[dotfiles][install] Installing chezmoi using wget."
    sh -c "$(wget -qO- https://git.io/chezmoi)" -- -b "$bin_dir"
  else
    echo "[dotfiles][install] To install chezmoi, you must have curl or wget installed." >&2
    exit 1
  fi
else
  chezmoi=chezmoi
fi

# POSIX way to get script's dir: https://stackoverflow.com/a/29834779/12156188
script_dir="$(cd -P -- "$(dirname -- "$(command -v -- "$0")")" && pwd -P)"
echo "[dotfiles][install] Initializing chezmoi with source directory: $script_dir'"
"$chezmoi" init --apply "--source=$script_dir"

default_source_dir="$HOME/.local/share/chezmoi"
if [ "$script_dir" != "$default_source_dir" ]; then
  echo "[dotfiles][install] Moving repository to default chezmoi source directory."
  mv "$script_dir" "$default_source_dir"
  echo "[dotfiles][install] Repository moved to '$default_source_dir'."
fi
