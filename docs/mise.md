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

## Environment Variables

Mise handles environment variables that were previously managed by direnv. This
is more efficient and centralizes the management of the environment.

## Migration from Devbox

Packages can be migrated from Devbox to Mise using the following approach:

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

### Migration Scripts

Helper scripts available for migration:

- `migrate-devbox-to-mise.sh`: Migrates packages from Devbox to Mise, checking
compatibility and availability
- `migrate-devbox-scripts-to-mise.sh`: Converts Devbox scripts to Mise tasks,
handling both simple and complex scripts

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
