# Package and Project Managers

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

## Mise

`mise` is cross-platform, and is the primary tool for both package and project
environment management (tasks/scripts and environment variables).

### Mise Global Environment

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

### Project Environment

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

### Mise Tasks

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

## Devbox

`devbox` is now deprecated but kept as a fallback for packages not available in
the Mise registry, particularly for macOS (darwin) where some packages like
`eza`, `aichat`, and `pnpm` are not available for macOS in the Mise registry
backends.

### Devbox Global Environment

For managing packages globally:

```sh
# Add a global package
devbox global add <package>

# Update global packages
devbox global update
```

The Devbox environment is automatically activated via direnv integration, so
there's no need to run `devbox shell` manually.

### Devbox Project Environment

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

## UPT

[UPT](https://github.com/sigoden/upt) is a cross-platform package manager
that wraps the default package manager shipped by the vendor on
each platform. Homebrew is the one exception, which is an external dependency.
It is also an exception in the sense that it *must not* be run with `sudo`. All
other platform's system package managers *do* require `sudo`.

For this reason Mise task `upt` is available. It is a Chezmoi template that
omits the `sudo` prefix on MacOS, and is used like

```sh
mise run upt install my-tool
```
