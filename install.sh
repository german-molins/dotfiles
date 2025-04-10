#!/bin/sh

# [dotfiles][install] This script installs chezmoi if not already installed,
# initializes it with the current script directory as the source, and applies
# the dotfiles by default. It supports switching to a specified git branch if it
# exists in the remote repository. If no branch is specified, or if the branch
# does not exist, the script defaults to not applying the dotfiles. The coned
# git repo is configured with the personal profile email address.

# Environment variables:
: ${DOTFILES_APPLY:-}
: ${DOTFILES_GIT_BRANCH:-}

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

# Set arguments for 'chezmoi init'.
set -- --source="${script_dir}"

if [ -n "${DOTFILES_GIT_BRANCH:-}" ]; then
    if git -C "${script_dir}" ls-remote --exit-code --heads origin "${DOTFILES_GIT_BRANCH}" >/dev/null; then
        >&2 echo "[dotfiles][install] Switching to git branch '${DOTFILES_GIT_BRANCH}'."
        git -C "${script_dir}" switch "${DOTFILES_GIT_BRANCH}"
    else
        >&2 echo -n "[dotfiles][install] ERROR: "
        >&2 echo "Branch '${DOTFILES_GIT_BRANCH}' does not exist in remote. "
        DOTFILES_APPLY=false
    fi
fi

echo "[dotfiles][install] Running 'chezmoi init $*'" >&2
"$chezmoi" init "$@"

personal_email="$("$chezmoi" data | jq .personal_email --raw-output)"
git -C "${script_dir}" config user.email "${personal_email}"

if [ "${DOTFILES_APPLY:-}" != "false" ]; then
    if [ -n "${DOTFILES_APPLY:-}" ] && [ "${DOTFILES_APPLY}" != "true" ]; then
        >&2 echo -n "[dotfiles][install] WARNING: "
        >&2 echo "DOTFILES_APPLY invalid value '$DOTFILES_APPLY', defaulting to 'true'."
    fi
    echo "[dotfiles][install] Running 'chezmoi apply'" >&2
    "$chezmoi" apply
else
    echo "[dotfiles][install] INFO: Not applying chezmoi after init." >&2
fi
