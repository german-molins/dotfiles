# My Dotfiles

Germán Molins' dotfiles, managed with [`chezmoi`](https://github.com/twpayne/chezmoi).

## Installation

There are several installation options.

## Install with `chezmoi`

Install as

    chezmoi init german-molins

## Install with `curl`

Run command

    sh -c "$(curl -fsLS get.chezmoi.io)" -- init --apply german-molins

## Installation Script

This installation option is very handy for tools that allow a dotfiles URL as
part of their configuration, like `devpod` or `vscode`.

Clone this repo and run the installation script,

    git clone https://github.com/german-molins/dotfiles.git
    dotfiles/install.sh

which will install the dotfiles and move the cloned repository to the default
`chezmoi` location.

## Main Tools And Apps

These are my daily CLI drivers:

- `chezmoi`: dotfiles manager
- `brew` / `nix`: package manager
- `alacritty` / `kitty`: terminal emulator
- `bash`: shell
- `devpod`: devcontainer manager
- `tmux`: terminal multiplexer
- `atuin`: shell history manager
- `ranger`: file manager
- `nvim`: text editor and IDE
- `gitui`: git manager
- `aichat`: all-in-one LLM tool
- `aider`: LLM pair programmer
- `task` / `timew`: task and time maneger
- `zk`: notebook manager
