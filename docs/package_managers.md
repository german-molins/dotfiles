# Package and Project Managers

These package managers are used to install the tools and apps at the user
level ("global"), depending on system and architecture:

- `mise`: primary global and project package manager
- `nix`: user package manager, driven through Mise's native `nix` bootstrap
  manager (no third-party plugin)
- `brew`: system package manager, driven through Mise's `brew`/`brew-cask`
  bootstrap managers
- `devbox`: retained only as a macOS entry point for installing Nix

Package Managers by operating system:

- macOS (ARM and AMD):
  - `mise`: tracked lock file; multi-user
  - `nix`: no tracked lock file; multi-user
  - `brew`: no tracked lock file; multi-user
- Linux AMD:
  - `mise`: tracked lock file; multi-user
  - `nix`: no tracked lock file; single-user
  - `brew`: no tracked lock file; multi-user
- Linux ARM:
  - `mise`: tracked lock file; multi-user
  - `nix`: no tracked lock file; single-user

Their priority order is:

1. `mise`: Primary package and project environment manager (tasks/scripts and
   environment variables). Tools are installed from the [Mise
registry](https://mise.jdx.dev/registry.html) or an explicit [Mise
backend](https://mise.jdx.dev/dev-tools/backends/) (`aqua`, `github`,
`gitlab`, `cargo`, `npm`, `pypi`, `conda`, `packslip`, …).
2. `mise` bootstrap packages: shared system/user packages declared under
   `[bootstrap.packages]` and installed with any of Mise's [bootstrap package
managers](https://mise.jdx.dev/bootstrap/packages/) (`brew`, `brew-cask`,
`nix`, `apt`, …). Used here for Homebrew formulae and casks (`brew:` /
`brew-cask:`) and for nixpkgs attributes (`nix:`) not packaged for the Mise
backends.
3. `brew` and `upt`: Used to install system dependencies. Bootstrapping them
   requires sudo permissions. The Homebrew CLI is kept for ad-hoc, *untracked*
installs; every *tracked* formula and cask is declared under
`[bootstrap.packages]` and installed by Mise (which needs no Homebrew CLI).

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

### Troubleshooting: mise.lock drift on apply

`chezmoi apply` may abort with `mise.lock has changed since chezmoi last
wrote it` (and, when unattended, `could not open a new TTY`). Cause: the
install script runs `mise install`, which rewrites `mise.lock` to the
versions actually installed on disk. When a `latest`-pinned tool has been
upgraded locally, the installed version diverges from the committed lock, so
the source lockfile changes underneath chezmoi mid-apply.

Reconcile *forward* (do not pin back to the stale version):

```sh
mise upgrade            # bring installed tools up to newest latest
chezmoi re-add          # rewrite source mise.lock to match disk
```

Then commit the updated `mise.lock`. `mise run mise:update` does the upgrade
step as part of the normal update flow, so running it before committing keeps
the lock from drifting again.

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

Shared, machine-wide system and user packages are declared under
`[bootstrap.packages]` in the global config and installed with a [bootstrap
package manager](https://mise.jdx.dev/bootstrap/packages/), spelled
`manager:package`.

Managers used here:

- `brew:` (formulae) and `brew-cask:` (casks) — Mise installs both directly
  into the canonical Homebrew prefix (`/opt/homebrew` on macOS ARM,
  `/home/linuxbrew/.linuxbrew` on Linux), pouring bottles and casks itself
  **without requiring the Homebrew CLI** ([brew manager
  docs](https://mise.jdx.dev/bootstrap/packages/brew.html#casks)). Mise and
  Homebrew share that one prefix.
- `nix:` — Mise installs the given nixpkgs attribute into the user's Nix
  profile (`~/.nix-profile/bin`), with **no shims and no sudo** ([nix manager
  docs](https://mise.jdx.dev/bootstrap/packages/nix.html)). Requires Nix 2.24+
  with the `nix-command` and `flakes` features and the modern `nix profile`
  CLI. Used for tools not packaged for the Mise backends (e.g. `taskwarrior3`,
  `gpg-tui`, `git-extras`). The shorthand resolves against the machine's
  nixpkgs registry.

#### Versioning: not lockfile-tracked

Unlike `[tools]` (recorded in `mise.lock`), bootstrap packages are **not
lockfile-tracked**. `"latest"` means *whatever the manager provides at apply
time*, and there is no version pinning in the lockfile sense:

- **`brew:` / `brew-cask:`** — `"latest"` tracks the current homebrew-core
  formula/cask. Explicit versions are not carried in a lockfile; a package may
  be upgraded on any `upgrade` run.
- **`nix:`** — version pins are **unsupported** (`nix:pkg@1.2` is skipped).
  A major version is selected only through the nixpkgs *attribute name*
  (`nix:taskwarrior2` vs `nix:taskwarrior3`), not a pin. `"latest"` is bounded
  by the machine's nixpkgs registry — Mise does not update flake registries
  itself, so the resolved version is whatever that registry currently points
  at.

So a tool **may be upgraded** during install/upgrade, and it stays declared as
`"latest"` (or its pinned attribute) — it never gains a lockfile entry.

macOS-only entries carry an `os` selector, so a single global declaration stays
cross-platform; nonmatching entries are skipped on apply (and `brew-cask` is
macOS-only for non-font casks regardless):

```toml
"brew:rsync" = "latest"
"brew-cask:firefox" = { os = "macos" }
"nix:taskwarrior3" = "latest"
```

```sh
# Declare + install a formula globally
mise bootstrap packages use -g brew:rsync
# Install everything declared, for every manager available on the host
# (idempotent; installs only what is missing)
mise bootstrap packages apply --yes
# Status
mise bootstrap packages status
```

`apply` installs only what is missing and **never removes or upgrades**
already-installed packages (the `chezmoi apply` path). Declarative removal
(uninstall what is no longer declared) is `mise bootstrap packages prune`,
wired into the `mise:clean` task rather than the `chezmoi apply` path so
applying is never destructive. Because the Homebrew prefix is shared, `prune`
removes *any* undeclared formula in it, so every formula to keep must be
declared (`brew-cask` prune is conservative — only Mise-owned cask artifacts).

`prune` does **not** cover the `nix:` manager: removing a `nix:` declaration
does not uninstall it, and there is no Mise prune for the Nix profile — remove
it natively with `nix profile remove` if needed.

Upgrading installed bootstrap packages (analogous to `brew upgrade`) is `mise
bootstrap packages upgrade`, wired into the `mise:update` task. This is the
only step that bumps installed versions; `apply` never does. For `nix:`, an
upgrade is bounded by the machine's nixpkgs registry (see above).

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

The `mise-nix` (aliased `devbox`) Mise backend plugin has been **removed**;
its packages migrated to Mise's native `nix:` bootstrap manager (see [Mise
Bootstrap Packages](#mise-bootstrap-packages)) or, where possible, to a Mise
backend (`conda`, `aqua`).

The [Devbox](https://www.jetpack.io/devbox/) CLI binary
(`~/.nix-profile/bin/devbox`) is kept **only** as a convenient entry point for
installing Nix on macOS; it is unrelated to the removed plugin. The
`devbox:self-update` task (`devbox version update`) keeps that CLI current.

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

- `packages.upt_linux` — Linux-only (gated in
  `home/.chezmoiscripts/run_onchange_after_20-install-upt-packages.sh.tmpl`).

Homebrew formulae and casks are no longer gated lists here; they moved to
`[bootstrap.packages]` (see [Mise Bootstrap Packages](#mise-bootstrap-packages)),
with an `os = "macos"` selector on the darwin-only casks and formulae in place of
the retired `brew bundle` mechanism.

## Known Limitations and Issues

Package-manager behaviours confirmed on the platforms noted. A tool or flow
**not** listed here is validated (installs and runs) on both macOS (arm64) and
Linux (x64) unless its own section says otherwise.

| Issue | Platform | Notes |
|-------|----------|-------|
| `brew-cask` for non-font casks | Linux | Unsupported by design — only font casks install on Linux; the darwin casks carry an `os = "macos"` selector and are skipped. |
| `mise bootstrap packages prune` for `brew-cask` | macOS | Conservative: removes only Mise-owned cask artifacts, not casks installed by the Homebrew CLI. |
