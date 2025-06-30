# My Dotfiles

Germán Molins' dotfiles, managed with [`chezmoi`](https://github.com/twpayne/chezmoi).

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
| [UPT](https://github.com/sigoden/upt) | `upt` | `mise upt --` | Cross-platform system package manager|
| [Alacritty](https://alacritty.org/) / [Kitty](https://sw.kovidgoyal.net/kitty/) | `alacritty` / `kitty` | | Terminal emulator |
| [Bash](https://devdocs.io/bash/) | `bash` | | Interactive shell |
| [Usage](https://devdocs.io/bash/) | `usage` | | Polyglot script CLI manager |
| [Devpod](https://devpod.sh/) | `devpod` | | Devcontainer manager |
| [Zellij](https://zellij.dev/) / [Tmux](https://github.com/tmux/tmux) | `zellij` / `tmux` | | Terminal workspaces / multiplexer |
| [Zoxide](https://github.com/ajeetdsouza/zoxide) | `zoxide`, `cd`, `cdi` | | Smarter `cd` |
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
| [Amazon Q Developer](https://docs.aws.amazon.com/amazonq/latest/qdeveloper-ug/) | `amazon-q` | `qchat`, `q` | LLM coding agent |
| [Aider](https://aider.chat/) | `aider` | | LLM pair programmer |
| [Taskwarrior](https://taskwarrior.org/) / [Timewarrior](https://timewarrior.net/) | `task` / `timew` | | Task and time manager |
| [Zk](https://zk-org.github.io/zk/) | `zk` | | Notebook manager |
| [Lnav](https://lnav.org/) | `lnav` | | Logfile navigator |

## Package and Project Managers

These package managers are used to install the tools and apps at the user
level ("global"), depending on system and architecture:

- `mise`: primary global and project package manager
- `devbox`: fallback global and project package manager
- `nix`: system and user package manager
- `brew`: system package manager

Package Managers by operating system:

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

1. `mise`: Primary package and project environment manager (tasks/scripts and
   environment variables)
2. `devbox`: Fallback for dependencies not found in `mise` registry
   (deprecated). Nixhub, the Devbox's registry, is way larger than any other,
so it's kept as a fallback option for packages not available in Mise,
particularly for macOS (darwin) where some packages like `eza`, `aichat`, and
`pnpm` are not supported by the Mise backends.
3. `brew` and `nix`: Used to install some user-level dependencies.
   Bootstrapping them requires sudo permissions, but once installed, the user
can use them to install packages without sudo.

### Mise

`mise` is cross-platform, and is the primary tool for both package and project
environment management (tasks/scripts and environment variables).

#### Mise Global Environment

For managing packages globally, e.g.

```sh
# Installs package globally
mise use -g fd
# Add ~/.local/config/config.{toml,lock}
chezmoi re-add
```

For packages available in the Aqua registry but not directly in Mise:

```sh
mise use -g aqua:organization/package@version
```

and

```sh
mise install
```

for installing the dependencies declared in `mise.toml` and `mise.lock`.

Update packages as

```sh
mise upgrade
```

or using the mise task:

```sh
mise run mise:update
```

Lock dependencies to specific versions:

```sh
mise run mise:lock
```

#### Project Environment

For managing a project, e.g.

```sh
cd your-project
mise use node
mise use python@3.11
git add mise.toml mise.lock
git commit -m "build: add node and python dependencies"
```

For instantiating a Mise-managed project, simply running

```sh
mise install
```

will install the dependencies declared in `mise.toml` and `mise.lock`.

#### Mise Tasks

Mise also manages tasks (scripts) that can be run with:

```sh
mise run task-name
```

To see all available tasks:

```sh
# Print list
mise tasks

# Interactize fuzzy search
mise run
```

### Devbox

`devbox` is now deprecated but kept as a fallback for packages not available in
the Mise registry, particularly for macOS (darwin) where some packages like
`eza`, `aichat`, and `pnpm` are not available for macOS in the Mise registry
backends.

#### Devbox Global Environment

For managing packages globally:

```sh
# Add a global package
devbox global add <package>

# Update global packages
devbox global update
```

The Devbox environment is automatically activated via direnv integration, so
there's no need to run `devbox shell` manually.

#### Devbox Project Environment

For managing a project with Devbox:

```sh
# Initialize a new project
cd your-project
devbox init

# Add project dependencies
devbox add <package>

# Install project dependencies
devbox install

# Update project dependencies
devbox update
```
