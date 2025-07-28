# My Dotfiles

Germán Molins' dotfiles, managed with [`chezmoi`](https://github.com/twpayne/chezmoi).

## About

The main goal of this project is to provide a state-as-code, fully reproducible
platform-independent PDE (personal development environment). This is achieved
by using this tool set:

- Dotfiles manager with templating support: Chezmoi
- Cross-platform package managers: Mise-In-Place, Devbox, UPT

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

## Main Tools And Apps

These are my daily CLI drivers:

| Name | Command | Alias | Description |
|------|---------|-------|-------------|
| [Chezmoi](https://www.chezmoi.io/) | `chezmoi` | | Dotfiles manager |
| [Mise](https://mise.jdx.dev/) | `mise` | | Global and project package manager |
| [Devbox](https://www.jetpack.io/devbox/) | `devbox` | | Global and project package manager |
| [UPT](https://github.com/sigoden/upt) | `upt` | `mise run upt` | Cross-platform system package manager|
| [Kitty](https://sw.kovidgoyal.net/kitty/) | `kitty` | | Terminal emulator |
| [Alacritty](https://alacritty.org/) | `alacritty` | | Terminal emulator |
| [Bash](https://devdocs.io/bash/) | `bash` | | Interactive shell |
| [Usage](https://devdocs.io/bash/) | `usage` | | Polyglot script CLI manager |
| [Devpod](https://devpod.sh/) | `devpod` | | Devcontainer manager |
| [Zellij](https://zellij.dev/) | `zellij` | `z{e,r}{,f,i}` | Terminal workspaces |
| [Tmux](https://github.com/tmux/tmux) | `tmux` | | Terminal multiplexer |
| [Zoxide](https://github.com/ajeetdsouza/zoxide) | `zoxide` | `cd`, `cdi` | Smarter `cd` |
| [Atuin](https://atuin.sh/) | `atuin` | | Shell history manager |
| [Yazi](https://yazi-rs.github.io/) | `yazi`, `ya` | `y` | File manager |
| [Neovim](https://neovim.io/) | `nvim` | | Text editor and IDE |
| [Git](https://git-scm.com/) | `git` | | Version control system |
| [Gitui](https://github.com/extrawurst/gitui) | `gitui` | `git ui` | Git manager |
| [Git Graph](https://github.com/mlange-42/git-graph) | `git-graph` | `git graph` | Git graph visualizer |
| [GitHub CLI](https://cli.github.com/) | `gh` | | GitHub CLI |
| [GitHub Dashboard](https://dlvhdr.github.io/gh-dash/) | `gh-dash` | `gh dash` | Pull requests and issues manager |
| [Lazydocker](https://github.com/jesseduffield/lazydocker) | `lazydocker` | | Docker and docker-compose manager |
| [AI Chat](https://github.com/sigoden/aichat) | `aichat` | `ai` | All-in-one LLM tool |
| [Amazon Q Developer](https://docs.aws.amazon.com/amazonq/latest/qdeveloper-ug/) | `amazon-q` | `qchat`, `azq`, `q` | LLM coding agent |
| [Aider](https://aider.chat/) | `aider` | | LLM pair programmer |
| [Taskwarrior](https://taskwarrior.org/) | `task` | | Task manager |
| [Timewarrior](https://timewarrior.net/) | `timew` | | Time manager |
| [Zk](https://zk-org.github.io/zk/) | `zk` | | Notebook manager |
| [Lnav](https://lnav.org/) | `lnav` | | Logfile navigator |

