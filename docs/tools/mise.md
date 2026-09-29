# Mise

[Mise](https://mise.jdx.dev/) is the primary package and environment manager
used in this dotfiles repository.

## Overview

Mise features and advantages:

- Lightweight installation and faster bootstrapping
- Cross-platform compatibility
- Integrated task management
- Environment variable management
- Project-specific configurations
- Reduced disk space usage compared to Nix-based solutions

## Configuration

Mise has been configured with some specific settings:

- Experimental features are enabled
- Lockfile is used to track exact versions
- Downloaded files are kept after installation
- Idiomatic version files are disabled (like ~/.python-version)

## Shell Integration

Mise is integrated with the shell through activation and completion hooks.

For activation performance optimizations during Bash startup, see [Startup
Caching](../bash.md#startup-caching).

## Shell Aliases

Mise manages shell-independent aliases

## Environment Variables

Mise handles environment variables, which centralizes the management of the
shell environment.

## Environments

Activated environments are managed by env var `MISE_ENV` as a comma-separated
list. Implemented global environments are

- `devbox`: Packages using plugin backend `mise-nix`
- `opt`: Optional packages (heavy or rarely used)

Currently they are all activated by default. When declaring project
environments locally, they must be appended to the value of activated global
environments, else the latter would be deactivated inside the Mise-managed
project. Example `mise.local.toml`:

```toml
[env]
MISE_ENV = "{{env.MISE_ENV}},prod,dev"
```

Environments take precedence over the base Mise environment, so to add a
package to a config file higher in the directory hierarchy one has to either
`cd`, use path option `-p` or, in the case of the global environment, clear the
`MISE_ENV` value as in

```sh
MISE_ENV= mise use -g tlrc
```

## Lazy Tools

Some global tools are declared with `lazy = true` (mise
[lazy tools](https://mise.jdx.dev/dev-tools/shims.html#lazy-tools)). The
motivation is a **fast fresh machine**: `chezmoi init --apply` runs a bare
`mise install`, which skips lazy tools, so a new machine only downloads the
tools its shell, apply scripts and daily workflow need. A side effect is
per-machine relevance: a machine only gets the rarely used tools it actually
calls.

A lazy tool installs the first time one of its commands is called, from any
context where the mise shims directory is on `PATH`: activated shells, chezmoi
run scripts and `install.sh` (see `mise-shellenv`), `mise x` and `mise run`.
After that it behaves like any other installed tool.

Everything is installed eventually, by design:

- `mise upgrade` (`mise:update`, `update`) installs every missing lazy tool, so
  the whole stack is kept up to date after the first update.
- `mise install --include-lazy` provisions everything at once.
- Until then, `mise doctor` and `mise ls --missing` report lazy tools as
  missing, so the `mise` and `tools-installed` project checks fail on a fresh
  machine.

### Criteria

A tool is lazy unless it falls into one of these groups:

- **Shell startup**: evaluated by `~/.bashrc.d` (usage, fnox, aube, zoxide,
  atuin, zellij, carapace); it would install on the first shell anyway.
- **Apply and update pipeline**: called by chezmoi run scripts, `install.sh` or
  `update` subtasks (neovim, yazi, upt, nono, pitchfork, pi, npm:skills, jq,
  jj, tree-sitter).
- **Backend providers**: runtimes other backends install through (node, python,
  uv, rust, cargo-binstall, mr-boxington).
- **System command overrides**: they shadow `/usr/bin` names used by any script
  (coreutils, conda:grep, conda:sed, conda:dash, cargo:findutils,
  cargo:diffutils, conda:tzdata).
- **Core daily or config dependencies**: bat (`PAGER`), fd, fzf, ripgrep, gh,
  lazygit, sd, yq, claude.
- **Indirect callers**: cosign (aqua verification), age (fnox keys), gh-dash and
  gh-stack (chezmoi resolves their gh extension symlinks with `lookPath`).

Registry shorthands get their shims from registry `bins` metadata. Explicit
backends (`aqua:`, `github:`, `cargo:`, `npm:`, `pypi:`, `conda:`) must list
their commands in `lazy_bins`; otherwise mise only warns and creates no shim:

```toml
"cargo:tlrc" = { version = "latest", lazy = true, lazy_bins = ["tldr"] }
```

Run `mise reshim` after editing lazy declarations and check it prints no
`invalid lazy shim declaration` warning.

## Tasks

### Integration with Usage

From [Usage documentation](https://usage.jdx.dev/cli/scripts),

> Scripts can be used with the Usage CLI to display help, powerful arg parsing,
> and autocompletion in any language.

Tasks that specify their CLI with Usage don't need to have the `usage` runtime
(or shebang `#!/bin/usr/env -S usage bash` for file tasks) for arg parsing,
completion and tasks docs generation to work, since `mise` already integrates
`usage`. This is convenient to prevent syntax highlighting, since the `usage`
shebang breaks it. However, it is necessary for standalone Usage scripts not
managed by `mise` directly as tasks.

## Project Diagnostics

The repository's health checks are declared as `[doctor.checks.<name>]` in the
local `mise.toml` and run with
[`mise doctor project`](https://mise.jdx.dev/configuration/project-diagnostics.html):

```sh
mise doctor project
mise doctor project --json
```

- **Repository**: `commit-authors`, `git-user-email`, `beads`, `task-docs-fresh`
- **Machine**: `chezmoi`, `mise`, `tools-installed`, `nvim`, `fnox`, `gh-auth`,
  `nix`

Machine checks live in the local config rather than the global one on purpose:
global checks would run in every project's `mise doctor project`.

Check output is discarded, so a failure only shows its description and hint.
Run the check's command directly to see why it failed.

## Managing Multiple Versions of the Same Tool

Mise supports installing several versions of the same tool, with the latest
taking precedence in activation hooks. The binaries of hidden versions can be
accessed through `mise which` as shown in the example below:

```sh
$ mise which node --tool=node@23 --cd="$HOME"
/Users/user/.local/share/mise/installs/node/23.11.1/bin/node

$ mise which node --cd="$HOME"
/Users/user/.local/share/mise/installs/node/24.9.0/bin/node
```

Declare multiple installed versions of the same tool in
`~/.config/mise/config.toml`:

```toml
node = ["latest", "23"]
```

See all the installed versions (global declared and per-project):

```sh
: mise list|rg node
node                              19.9.0
node                              20.13.1
node                              22.19.0
node                              23.11.1                 ~/.config/mise/config.toml         23
node                              24.6.0
node                              24.7.0
node                              24.9.0                  ~/.config/mise/config.toml         latest
```

or

```sh
: mise tool node
Backend:            core:node
Installed Versions: 19.9.0 20.13.1 22.19.0 23.11.1 24.6.0 24.7.0 24.9.0
Active Version:     24.9.0
Requested Version:  latest
Config Source:      ~/.config/mise/config.toml
Tool Options:       [none]
```

## Troubleshooting

If installed tools that should be in `PATH` can't be correctly resolved,
sometimes a re-shim is in order,

```sh
mise reshim nvim
```

or an incorrect version is installed and the tool needs to be re-installed,

```sh
mise uninstall --all nvim && mise install nvim
```
