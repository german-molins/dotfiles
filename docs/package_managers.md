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
   environment variables). Packages installed from the Mise registry or using
backends `aqua`, `github`, `gitlab`, `npm`.
2. `mise-nix` (aliased `devbox`) Mise backend plugin: Nixhub, the Devbox's
   registry, is way larger than any other, so it's kept as a fallback option
for packages not available in Mise, particularly for macOS (darwin) where some
packages like `eza` are not supported by the Mise backends.
3. `brew` and `upt`: Used to install system dependencies. Bootstrapping them
   requires sudo permissions.

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
mise lock
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

[Devbox](https://www.jetpack.io/devbox/) integration has been removed but its installation has been temporarily kept as an
working entry point for installing Nix indirectly in macOS. Mise backend plugin
`mise-nix` (aliased `devbox`) is then used to install packages from the Nixhub
registry, which requires Nix as a system dependency.

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
