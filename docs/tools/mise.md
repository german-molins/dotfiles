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
  gh-stack (`gh` runs them through symlinks to their mise shims).
- **Agent skill providers**: packslip tools whose skills a bare `mise install`
  must fetch (worktrunk); see [Agent Skills](#agent-skills).

Registry shorthands get their shims from registry `bins` metadata. Explicit
backends (`aqua:`, `github:`, `cargo:`, `npm:`, `pypi:`, `conda:`) must list
their commands in `lazy_bins`; otherwise mise only warns and creates no shim:

```toml
"cargo:tlrc" = { version = "latest", lazy = true, lazy_bins = ["tldr"] }
```

Run `mise reshim` after editing lazy declarations and check it prints no
`invalid lazy shim declaration` warning.

## Agent Skills

Tools installed with the
[packslip backend](https://mise.jdx.dev/dev-tools/backends/packslip.html) can
declare [agent skills](https://mise.jdx.dev/dev-tools/packslip-resources.html#skills)
in their signed release manifest. mise fetches them into each version's install
directory during `mise install`; `mise skills ls` lists those of the active
tools.

`run_onchange_after_10-install-mise-packages.sh` links them, right after
`mise install` and under the same `mise.lock` trigger, into both agent skill
directories:

```sh
mise -C "$HOME" skills sync --dir "$HOME/.agents/skills" --prune
mise -C "$HOME" skills sync --dir "$HOME/.claude/skills" --prune
```

- **Lifecycle**: any version bump changes `mise.lock`, so the next
  `chezmoi apply` re-points the links to the new install. Between a manual
  `mise upgrade` and that apply, links may dangle.
- **Idempotency**: sync only replaces or prunes links it owns (pointing into
  the mise installs directory); handwritten skills and `npx skills` links are
  left alone and name clashes are reported as skipped.
- **Fresh machines**: the script runs after `mise install`, which fetches the
  skills first. Lazy tools fetch theirs only once installed.
- **No filtering**: sync links every skill of every active tool. Excluding one
  requires an allowlist on top of `mise skills ls --json`; not worth it yet.
- `skills.auto_sync` is not used: it only runs inside a mise project and
  targets a single `skills.dir`.

Packslip tools in the global config that ship skills:

| Tool | Skills | Linked |
|------|--------|--------|
| aube | `aube` | ✓ |
| fnox | `fnox` | ✓ |
| mr-boxington | `mbx` | ✓ |
| pitchfork | `pitchfork` | ✓ |
| usage | `usage` | ✓ |
| worktrunk | `worktrunk`, `wt-switch-create` | ✓ |

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

## Daemons

Projects declare their dev stack in `[daemons]` and run it with
[`mise daemons`](https://mise.jdx.dev/daemons.html#declare-a-daemon), which
drives [Pitchfork](../global_services.md) under the hood. Each git worktree gets
its own isolated set of daemons.

- **Ports**: declare a base port; the primary checkout uses it and every other
  worktree gets a fixed per-worktree offset
  ([ports across git worktrees](https://mise.jdx.dev/daemons.html#ports-across-git-worktrees)).
  Never hardcode ports elsewhere; `mise daemons urls` shows the current ones.
- **Registration**: every checkout is registered as a namespace in
  `~/.config/pitchfork/config.toml`, the same file that holds the user
  services. See [Shared with Mise Daemons](../global_services.md#shared-with-mise-daemons)
  for why chezmoi manages it with a modify template and how entries of deleted
  worktrees get cleaned up.
- **Global daemons**: `[daemons]` in the global config
  [join every project's set](https://mise.jdx.dev/daemons.html#configuration-inheritance)
  and can't run outside a project, so user-level services stay in pitchfork.
- **Supervisor at login**: here `pitchfork boot enable`
  (`run_onchange_after_15-enable-pitchfork-boot.sh.tmpl`) keeps the supervisor
  available
  ([keep the supervisor available at login](https://mise.jdx.dev/daemons/development-stack.html#keep-the-supervisor-available-at-login)).

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
