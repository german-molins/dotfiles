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
   environment variables). Tools are installed from the [Mise
registry](https://mise.jdx.dev/registry.html) or an explicit [Mise
backend](https://mise.jdx.dev/dev-tools/backends/) (`aqua`, `github`,
`gitlab`, `cargo`, `npm`, `pypi`, `conda`, `packslip`, …).
2. `mise` bootstrap packages: shared system packages declared under
   `[bootstrap.packages]` and installed with any of Mise's [bootstrap package
managers](https://mise.jdx.dev/bootstrap/packages/) (`brew`, `brew-cask`,
`apt`, `nix`, …). Used here for Homebrew formulae.
3. `mise-nix` (aliased `devbox`) Mise backend plugin: Nixhub, the Devbox's
   registry, is way larger than any other, so it's kept as a fallback option
for packages not available in Mise, particularly for macOS (darwin) where some
packages like `eza` are not supported by the Mise backends.
4. `brew` and `upt`: Used to install system dependencies. Bootstrapping them
   requires sudo permissions. `brew` casks and darwin-only formulae are still
installed by a custom `brew bundle` mechanism (see below) pending migration to
`mise` bootstrap packages.

## Mise

`mise` is cross-platform, and is the primary tool for both package and project
environment management (tasks/scripts and environment variables).

### Mise Global Environment

For managing packages globally, e.g.

```sh
# Installs package globally
mise use -g fd
# Updates ~/.config/mise/config.toml (and mise.lock)
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

### Mise Backends

When a tool is not in the [registry](https://mise.jdx.dev/registry.html), an
explicit [backend](https://mise.jdx.dev/dev-tools/backends/) is used as the
installation source, spelled `backend:tool` in `mise use`/`config.toml`.
Backends in use here:

- `aqua` — curated binary recipes (no aqua CLI required)
- `github` / `gitlab` — release assets
- `cargo` — Rust crates
- `npm` — npm packages
- `pypi` — Python packages
- `conda` — conda-forge binaries
- `packslip` — signed publisher manifests

### Mise Bootstrap Packages

Shared, machine-wide system packages are declared under `[bootstrap.packages]`
in the global config and installed with a [bootstrap package
manager](https://mise.jdx.dev/bootstrap/packages/), spelled `manager:package`.
Homebrew formulae use the `brew:` manager, which Mise installs directly into
the canonical Homebrew prefix (`/home/linuxbrew/.linuxbrew` on Linux) — pouring
bottles itself, **without requiring the Homebrew CLI**. Mise and Homebrew share
that one prefix.

```sh
# Declare + install a formula globally
mise bootstrap packages use -g brew:rsync
# Install everything declared (idempotent; installs only what is missing)
mise bootstrap packages apply --manager brew --yes
# Status
mise bootstrap packages status
```

`apply` never removes packages. Declarative removal (uninstall what is no
longer declared) is `mise bootstrap packages prune`, wired into the `mise:clean`
task rather than the `chezmoi apply` path so applying is never destructive.
Because the prefix is shared, `prune` removes *any* undeclared formula in it,
so every formula to keep must be declared.

The mise install script
(`run_onchange_after_10-install-mise-packages.sh.tmpl`) applies them, so
`chezmoi apply` installs them.

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

## Platform Gates for Package Lists

Package lists in `home/.chezmoidata/packages.yaml` are gated per-platform by
suffixing the list key. The install scripts iterate the common list
unconditionally, then iterate any platform-specific siblings inside a
<span v-pre>`{{ if eq .chezmoi.os "<os>" }}`</span> guard.

Conventions:

- `<manager>`: common to all platforms.
- `<manager>_darwin`: macOS-only.
- `<manager>_linux`: Linux-only.

Current gated lists:

- `packages.homebrew.brews_darwin` and `packages.homebrew.casks` — macOS-only
  (gated in `home/.chezmoiscripts/run_onchange_after_05-install-homebrew-packages.sh.tmpl`).
- `packages.upt_linux` — Linux-only (gated in
  `home/.chezmoiscripts/run_onchange_after_20-install-upt-packages.sh.tmpl`).

Homebrew formulae common to all platforms are no longer a gated list here; they
moved to `[bootstrap.packages]` (see [Mise Bootstrap
Packages](#mise-bootstrap-packages)). Only darwin casks and formulae remain on
this custom `brew bundle` mechanism, pending their migration too.
