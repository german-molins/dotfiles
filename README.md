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

### Apps

These are my daily CLI drivers:

| Name | Command | Alias | Description |
|------|---------|-------|-------------|
| Chezmoi | `chezmoi` | | Dotfiles manager |
| Alacritty / Kitty | `alacritty` / `kitty` | | Terminal emulator |
| Bash | `bash` | | Interactive shell |
| Devpod | `devpod` | | Devcontainer manager |
| Zellij / Tmux | `zellij` / `tmux` | | Terminal workspaces / multiplexer |
| Zoxide | `zoxide`, `z`, `zi` | | Smarter `cd` |
| Atuin | `atuin` | | Shell history manager |
| Ranger | `ranger` | | File manager |
| Neovim | `nvim` | | Text editor and IDE |
| Git | `git` | | Version control system |
| Gitui | `gitui` | `git ui` | Git manager |
| Git Graph | `git-graph` | `git graph` | Git graph visualizer |
| GitHub CLI | `gh` | | GitHub CLI |
| GitHub Dashboard | `gh-dash` | `gh dash` | Pull requests and issues manager |
| Lazydocker | `lazydocker` | | Docker and docker-compose manager |
| AI Chat | `aichat` | `ai` | All-in-one LLM tool |
| Aider | `aider` | | LLM pair programmer |
| Taskwarrior / Timewarrior | `task` / `timew` | | Task and time manager |
| Zk | `zk` | | Notebook manager |

### Package Managers by Operating System

These package managers are used to install the tools and apps at the user
level ("global"), depending on system and architecture:

Package managers:

- `devbox`: user and project package manager
- `nix`: system and user package manager
- `brew`: system package manager

Operating systems:

- macOS (ARM and AMD):
  - `devbox`: tracked lock file; multi-user
  - `nix`: no tracked lock file; multi-user
  - `brew`: no tracked lock file; multi-user
- Linux AMD:
  - `devbox`: tracked lock file; single-user
  - `nix`: no tracked lock file; single-user
  - `brew`: no tracked lock file; multi-user
- Linux ARM:
  - `devbox`: tracked lock file; single-user
  - `nix`: no tracked lock file; single-user

`brew` and `nix` are used to install user-level dependencies. Bootstrapping
them requires sudo permissions, but once installed, the user can use them to
install packages without sudo. `devbox` is installed by `nix` and `asdf` is
installed by `brew`.

#### Devbox

`debbox` is a package manager that can instal packages globally (user level)
and per project. It is a very convenient manager for project shell
environments.

**Global environment**

For managing packages globally, e.g.

```sh
# Installs package and updates dependencies file and lock file.
devbox global add aider
cd "$DEVBOX_PROJECT_ROOT"
chezmoi add devbox.json devbox.lock
```

and

```sh
devbox global install
```

for installing the dependencies declared in `devbox.json` and `devbox.lock`.

Update packages as

```sh
devbox global update
```

**Project Environment**

For managing a project, e.g.

```sh
devbox init
devbox add yq
git add devbox.json devbox.lock
git commit -m "build: add package yq"
```

For instantiating a Devbox-managed project, simply running

```sh
devbox install
```

will install the dependencies declared in `devbox.json` and `devbox.lock`.
