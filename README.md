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
| Mise | `mise` | | Global and project package manager |
| Devbox | `devbox` | | Global and project package manager |
| Alacritty / Kitty | `alacritty` / `kitty` | | Terminal emulator |
| Bash | `bash` | | Interactive shell |
| Devpod | `devpod` | | Devcontainer manager |
| Zellij / Tmux | `zellij` / `tmux` | | Terminal workspaces / multiplexer |
| Zoxide | `zoxide`, `cd`, `cdi` | | Smarter `cd` |
| Atuin | `atuin` | | Shell history manager |
| Yazi | `yazi`, `ya` | `y` | File manager |
| Neovim | `nvim` | | Text editor and IDE |
| Git | `git` | | Version control system |
| Gitui | `gitui` | `git ui` | Git manager |
| Git Graph | `git-graph` | `git graph` | Git graph visualizer |
| GitHub CLI | `gh` | | GitHub CLI |
| GitHub Dashboard | `gh-dash` | `gh dash` | Pull requests and issues manager |
| Lazydocker | `lazydocker` | | Docker and docker-compose manager |
| AI Chat | `aichat` | `ai` | All-in-one LLM tool |
| Amazon Q | `amazon-q` | `qchat`, `q` | LLM coding agent |
| Aider | `aider` | | LLM pair programmer |
| Taskwarrior / Timewarrior | `task` / `timew` | | Task and time manager |
| Zk | `zk` | | Notebook manager |
| Lnav | `lnav` | | Logfile navigator |

### Package Managers by Operating System

These package managers are used to install the tools and apps at the user
level ("global"), depending on system and architecture:

- `mise`: global and project package manager
- `devbox`: global and project package manager
- `nix`: system and user package manager
- `brew`: system package manager

Operating systems:

- macOS (ARM and AMD):
  - `mise`: tracked lock file; multi-user
  - `devbox`: tracked lock file; multi-user
  - `nix`: no tracked lock file; multi-user
  - `brew`: no tracked lock file; multi-user
- Linux AMD:
  - `mise`: tracked lock file; multi-user
  - `devbox`: tracked lock file; single-user
  - `nix`: no tracked lock file; single-user
  - `brew`: no tracked lock file; multi-user
- Linux ARM:
  - `mise`: tracked lock file; multi-user
  - `devbox`: tracked lock file; single-user
  - `nix`: no tracked lock file; single-user

Their priority order is:

1. `mise`: Main package and project environment manager
2. `devbox`: Fallback for dependencies not found in `mise` or `aqua` registry.
   Nixhub, the Devbox's registry, is way larger than any other.
3. `brew` and `nix`: Used to install some user-level dependencies.
   Bootstrapping them requires sudo permissions, but once installed, the user
can use them to install packages without sudo. `devbox` is installed by `nix`
on Linux and bootstrapped in macOS.

#### Mise

`mise` is cross-platform, and is both a package and project environment manager
(tasks/scripts and environment variables).

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
