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

Mise is integrated with the shell through activation and completion hooks. This
replaces the previous direnv-based approach used with Devbox.

For activation performance optimizations during Bash startup, see [Mise Caching
Optimization](../bash.md#mise-caching-optimization).

## Shell Aliases

Mise manages shell-independent aliases

## Environment Variables

Mise handles environment variables that were previously managed by direnv. This
is more efficient and centralizes the management of the environment.

## Migration from Devbox

### Aproach 1: Direct Migration

Packages can be migrated from Devbox to Mise using the following approach,
which works for packages from Nixhub registry (backend used by Devbox) that are
also in the Mise registry or in some of the backend registries supported by
Mise:

1. Check if the package is available in Mise registry or Aqua registry
2. Use `mise use -g package@version` to add it to Mise
3. Remove it from Devbox with `devbox global remove package`

Some packages may need to remain in Devbox due to platform limitations:

- `eza`, `aichat`, and `pnpm` are examples of packages not available for macOS
in the Mise registry

Devbox scripts can be migrated to Mise tasks by:

1. Converting single-line scripts to entries in `config.toml`
2. Converting multi-line scripts to task files with appropriate grouping
3. Replacing any references to `devbox global run` with `mise run`

### Approach 2: Using Mise Backend Plugin `mise-nix`

[`mise-nix`](https://github.com/jbadeau/mise-nix) is a [backend
plugin](https://mise.jdx.dev/plugin-usage.html#backend-plugins) that provides
support for installing packages from [Nixhub](https://www.nixhub.io/) registry
("built for devbox by [jetify](https://www.jetify.com/)") or from flakes as
git links. It provides the same packaging source as Devbox, with the benefits
of managing them with Mise, except for these current limitations:

- `mise upgrade` not supported for these packages. See [the issue I
opened](https://github.com/jbadeau/mise-nix/issues/7), which the author found
out to be actually a Mise bug, for which he opened a
[discussion](https://github.com/jdx/mise/discussions/5909).

### Migration Scripts

Helper scripts available for migration:

- `migrate-devbox-to-mise.sh`: Migrates packages from Devbox to Mise, checking
compatibility and availability
- `migrate-devbox-scripts-to-mise.sh`: Converts Devbox scripts to Mise tasks,
handling both simple and complex scripts

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
