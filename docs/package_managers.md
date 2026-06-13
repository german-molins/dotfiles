# Package and Project Managers

These package managers are used to install the tools and apps at the user
level ("global"), depending on system and architecture:

- `mise`: primary global and project package manager
- `devbox`: fallback global and project package manager — **soon to be deprecated**
- `nix`: system and user package manager
- `brew`: system package manager

Package Managers by operating system:

- macOS (ARM and AMD):
  - `mise`: tracked lock file; multi-user
  - `devbox`: tracked lock file; multi-user — **soon to be deprecated**
  - `nix`: no tracked lock file; multi-user
  - `brew`: no tracked lock file; multi-user
  - `mise system` (`brew:` manager): no tracked lock file; multi-user ¹
- Linux AMD:
  - `mise`: tracked lock file; multi-user
  - `devbox`: tracked lock file; single-user — **soon to be deprecated**
  - `nix`: no tracked lock file; single-user
  - `brew`: no tracked lock file; multi-user
  - `mise system` (`brew:` manager): no tracked lock file; multi-user ¹
- Linux ARM:
  - `mise`: tracked lock file; multi-user
  - `devbox`: tracked lock file; single-user — **soon to be deprecated**
  - `nix`: no tracked lock file; single-user
  - `mise system` (`brew:` manager): no tracked lock file; multi-user ¹

¹ `mise system` `brew:` manager (experimental) pours `homebrew/core`
bottles into the canonical Homebrew prefix on its own. No real
Homebrew required on the 3 supported platforms. Coverage and gaps
in [Mise System Packages](#mise-system-packages-experimental).

² Linux ARM has no `brew` row by design: a real Homebrew install on
Linux ARM is deliberately avoided, and `mise system` covers the
need (see [Mise System Packages](#mise-system-packages-experimental)).

Their priority order is:

1. `mise`: Primary package and project environment manager (tasks/scripts and
   environment variables). Packages installed from the Mise registry or using
backends `aqua`, `github`, `gitlab`, `npm`.
2. `mise system` (`[system.packages]` `brew:` manager): system-wide libraries
   and dependencies from `homebrew/core` — see [Mise System
   Packages](#mise-system-packages-experimental).
3. `brew` and `upt`: Used to install system dependencies that mise system
   cannot (casks, tapped formulae, darwin-amd64). Bootstrapping them
   requires sudo permissions.
4. `mise-nix` (aliased `devbox`) Mise backend plugin: Nixhub, the Devbox's
   registry, is way larger than any other, so it's kept as a fallback option
   for packages not available in Mise or `homebrew/core`, particularly for
   macOS (darwin) where some packages like `eza` are not supported by the
   Mise backends. **Soon to be deprecated** — see [Devbox](#devbox).

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

## Mise System Packages (experimental)

For machine-wide libraries and dependencies that don't need to be mise-resolved
per-project, declare them under `[system.packages]` in
`~/.config/mise/config.toml`:

```sh
# Add a homebrew/core formula and install it
mise system use -g brew:ffmpeg
# Pin a version (core formulae only)
mise system use -g brew:postgresql@17
# Apply [system.packages] from the active config
mise system install
```

Coverage and limitations:

- **Platforms**: macOS-arm64, Linux-x86_64, Linux-arm64. ❌ **darwin-amd64
  (Intel Mac)** — reports unavailable; use real `brew` or Nix.
- **No real Homebrew required** for `homebrew/core` formulae; mise pours
  bottles from `ghcr.io` itself.
- **Casks NOT supported** — `packages.homebrew.casks` stays on real `brew`.
- **Tapped formulae NOT supported** — delegated to real `brew` if present.
- **No `@version` pinning** for non-core formulae.
- The `brew:` manager is **experimental**; status:
  `mise system status`, install: `mise system install`, upgrade:
  `mise system upgrade`.

## Devbox

⚠️ **Soon to be deprecated.** The devbox environment is being phased out in
favor of `mise system` (see [Migration Status](#migration-status-devbox--mise-system-brew)).
The mise-nix plugin (aliased `devbox`), `home/mise.devbox.toml`,
`home/mise.devbox.lock`, and the `devbox:self-update` task remain in place
only to support the few devbox entries still pending migration.

### History

[Devbox](https://www.jetpack.io/devbox/) integration has been removed but its
installation was kept in place as a working entry point for installing Nix
indirectly in macOS, with the `mise-nix` (aliased `devbox`) backend plugin
pulling packages from the Nixhub registry. That role is now superseded by
[mise system `brew:`](#mise-system-packages-experimental); the devbox
scaffolding remains only to host the migration tail.

### Migration Status (devbox → mise system `brew:`)

| devbox: name    | → | brew: name       | Status                       |
|-----------------|---|------------------|------------------------------|
| exiftool        | → | `brew:exiftool`    | ✅ migrated                  |
| taskwarrior     | → | `brew:task`        | ✅ migrated                  |
| timewarrior     | → | `brew:timewarrior` | ✅ migrated                  |
| file            | → | `brew:file-formula`| ✅ migrated (formula alias)  |
| readline        | → | `brew:readline`    | ✅ migrated                  |
| git-extras      | → | `brew:git-extras`  | ✅ migrated                  |
| ffmpeg          | → | `brew:ffmpeg`      | ⏸ held back (env) ³          |
| gpg-tui         | → | `brew:gpg-tui`     | ⏸ held back (env) ³          |
| poppler-utils   | → | `brew:poppler`     | ⏸ held back (env) ³          |
| git             | → | `brew:git`         | ⏸ held back (env) ³          |

³ Held back on this box due to a linuxbrew-prefix file conflict
(`alsa-lib` and `ca-certificates` are depended on by other brew formulae
and were not created by mise's bottle linker). Reproducible with a
stale `/home/linuxbrew/.linuxbrew` prefix. This is an **environment**
issue, not a mise limitation. Likely fixable with a clean linuxbrew
prefix (fresh install, or `brew reinstall <conflicting-formula>` for
the 2 above).

### Roadmap to drop devbox/mise-nix

1. Unblock the 4 held-back entries on the current box (clean
   linuxbrew prefix, or move them to real `brew`).
2. Migrate them to `mise system` `brew:` on macOS (where they all
   exist in `homebrew/core`).
3. Remove `[plugins] devbox = "..."` from `home/dot_config/mise/config.toml`.
4. Remove `[tasks.devbox:self-update]` and the `devbox:self-update`
   dependency in `[tasks.self-update]`.
5. Delete `home/mise.devbox.toml` and `home/mise.devbox.lock`.
6. Drop the devbox-install step from
   `home/.chezmoiscripts/run_onchange_before_00-bootstrap.sh.tmpl` and
   make the nix-installer hook optional (or remove it entirely).

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
