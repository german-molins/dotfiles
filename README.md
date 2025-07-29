# My Dotfiles

Germán Molins' dotfiles, managed with [`chezmoi`](https://github.com/twpayne/chezmoi).

## About

The main goal of this project is to provide a state-as-code, fully reproducible
platform-independent PDE (personal development environment). This is achieved
by using this tool set:

- Dotfiles manager with templating support: Chezmoi
- Cross-platform package managers: Mise-In-Place, Devbox, UPT

For more information see the [documentation](https://german-molins.github.io/dotfiles/).

## Installation

There are several installation options.

## Install with `chezmoi`

Install as

```sh
chezmoi init german-molins
```

## Install with `curl`

Run command

```sh
sh -c "$(curl -fsLS get.chezmoi.io)" -- init --apply german-molins
```

## Installation Script

This installation option is very handy for tools that allow a dotfiles URL as
part of their configuration, like `devpod` or `vscode`.

Clone this repo and run the installation script,

```sh
git clone https://github.com/german-molins/dotfiles.git
dotfiles/install.sh
```

which will install the dotfiles and move the cloned repository to the default
`chezmoi` location.
