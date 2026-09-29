# Package and Project Managers

Package managers fall into three categories by the kind of package they
manage:

| Category | Manages | Managers |
|----------|---------|----------|
| System | OS-level and machine-wide packages | `upt` (native OS manager, sudo), Homebrew |
| User (global) | User-wide CLI tools and apps | Mise `[tools]` and backends, Mise bootstrap `nix:` |
| Per-tool | A tool's own plugins, extensions or packs | See [Per-tool Package Managers](#per-tool-package-managers) |

Mise drives the first two: it installs system packages through `upt` and
Homebrew formulae through its `brew:` bootstrap manager. Per-tool managers are
the package managers built into a tool itself.

## Bootstrap and Dependencies

`install.sh` installs chezmoi, which bootstraps every other package manager
through its scripts. mise then installs tools, bootstrap packages, system
packages (via `upt`) and editor plugins (via its tasks):

```d2
direction: down

install: install.sh {shape: page}

bin: "~/.local/bin" {
  note: "on PATH via ~/.profile\nand .bashrc.d/17-mise.sh" {shape: text}
  chezmoi
  mise: "mise\n(pinned in packages.yaml)"
}

scripts: chezmoi scripts {
  before: before_00-bootstrap
  after: after_10…82
}

system: System {
  brew: Homebrew {
    cli: brew CLI
    cellar: Cellar {shape: cylinder}
    cli -> cellar: ad-hoc
  }
  apt: system packages {shape: cylinder}
}

user: User (global) {
  nix: Nix {
    profile: user profile {shape: cylinder}
  }
  tools: "mise [tools]\n(locked in mise.lock)" {shape: cylinder}
}

pertool: Per-tool {
  plugins: "nvim, yazi, nono,\npi, skills, Claude Code,\nmise plugins" {shape: cylinder}
}

install -> bin.chezmoi: get.chezmoi.io
bin.chezmoi -> scripts: runs
scripts.before -> bin.mise: mise.run
scripts.before -> system.brew.cli: "linux-x64, macOS"
scripts.before -> user.nix: "nix.enabled\n(macOS via Devbox)"
scripts.after -> bin.mise: "10, 20, 62, 75"
scripts.after -> pertool.plugins: "82 nono pull"
bin.mise -> user.tools
bin.mise -> system.brew.cellar: "bootstrap brew:"
bin.mise -> user.nix.profile: "bootstrap nix:"
bin.mise -> system.apt: "upt (sudo)"
bin.mise -> pertool.plugins: "nvim, yazi tasks"
```

chezmoi is deliberately not a mise tool: it sits at the root of the chain and
has to work when mise does not. `~/.local/bin` holds both chezmoi and the mise
binary, and is put on `PATH` independently of mise by `~/.profile` (any POSIX
login shell) and by `.bashrc.d/17-mise.sh` (bash and chezmoi scripts, before
`mise activate`). mise declares it again in `[env] _.path` as the canonical
location; mise does not deduplicate `PATH`, so the entry appears twice, which
is harmless. If mise startup breaks, `chezmoi` is still on `PATH` to repair
the setup.

Homebrew is bootstrapped only on `linux-x64` and macOS. Nix is gated by
`nix.enabled` (`DOTFILES_NIX_ENABLED`); on macOS it is installed through
the Devbox installer, on Linux with the official installer.

### Updates

`mise run update` runs one subtask per manager. Tracked files are re-added to
the chezmoi source and committed as `build(<scope>): update packages`; the
rest change the system without leaving anything to commit:

```d2
direction: right

update: mise run update

tasks: subtasks {
  system: System {
    brew: brew:update
    upt: upt:update
  }
  user: User (global) {
    chezmoi: chezmoi:update
    mise: mise:update
  }
  pertool: Per-tool {
    yazi: yazi:update
    nvim: nvim:update
    pi: pi:update
    agents: agents:update
  }
}

tracked: tracked in home/ {
  lock: mise/mise.lock {shape: document}
  yazi: yazi/package.toml {shape: document}
  nvim: nvim/lazy-lock.json {shape: document}
  pi: dot_pi/agent/settings.json {shape: document}
  skills: dot_agents/dot_skill-lock.json {shape: document}
}

untracked: untracked {
  chezmoi: "~/.local/bin/chezmoi"
  cellar: Homebrew Cellar
  nix: Nix profile
  apt: system packages
}

update -> tasks
tasks.user.chezmoi -> untracked.chezmoi: chezmoi upgrade
tasks.user.mise -> tracked.lock: mise upgrade
tasks.user.mise -> untracked.cellar: bootstrap upgrade
tasks.user.mise -> untracked.nix: bootstrap upgrade
tasks.pertool.yazi -> tracked.yazi: ya pkg upgrade
tasks.pertool.nvim -> tracked.nvim: "Lazy! update"
tasks.pertool.pi -> tracked.pi: pi update
tasks.system.brew -> untracked.cellar: brew upgrade
tasks.system.upt -> untracked.apt: "upt upgrade (sudo)"
tasks.pertool.agents -> tracked.skills: "skills update -g"
```

## Package Sources

Every user-level ("global") tool and app is installed through **Mise**, which
drives all package sources from one config (`~/.config/mise/config.toml`). The
sources differ in how they are declared, whether they are version-locked, and
where they install to:

| Source | Spelled | Declared in | Version-locked | Installs into |
|--------|---------|-------------|:--------------:|---------------|
| Mise registry | `tool` | `[tools]` | `mise.lock` | Mise shims |
| Mise backend | `backend:tool` | `[tools]` | `mise.lock` | Mise shims |
| Bootstrap `brew` | `brew:formula` | `[bootstrap.packages]` | — | shared Homebrew prefix |
| Bootstrap `brew-cask` | `brew-cask:cask` | `[bootstrap.packages]` | — | shared Homebrew prefix |
| Bootstrap `nix` | `nix:attr` | `[bootstrap.packages]` | — | user Nix profile |
| System deps | native name | `packages.yaml` / ad-hoc | — | OS package database |

Only `[tools]` are recorded in `mise.lock`; bootstrap packages and system deps
track *latest* at install time (see [Mise Bootstrap
Packages](#mise-bootstrap-packages)).

### Source precedence

Prefer sources top-down; drop to the next only when a tool is unavailable:

1. **Mise registry / backend** (`[tools]`) — first choice: cross-platform,
   version-locked in `mise.lock`, and shimmed. Covers almost everything, from
   the [registry](https://mise.jdx.dev/registry.html) or an explicit
   [backend](https://mise.jdx.dev/dev-tools/backends/) (`aqua`, `github`,
   `gitlab`, `cargo`, `npm`, `pypi`, `conda`, `packslip`, …).
2. **Mise bootstrap packages** (`[bootstrap.packages]`) — shared system/user
   packages Mise installs *without* their native CLI, via a [bootstrap package
   manager](https://mise.jdx.dev/bootstrap/packages/):
   - `brew:` / `brew-cask:` — Homebrew formulae and casks, poured into the
     shared Homebrew prefix (no Homebrew CLI needed).
   - `nix:` — nixpkgs attributes into the user's Nix profile (needs Nix on
     `PATH`), for tools not packaged for the Mise backends.
3. **System package managers** (`brew`, `upt`) — OS-level dependencies that
   must be bootstrapped with sudo (Homebrew excepted). The Homebrew CLI is
   kept only for ad-hoc, *untracked* installs.

### Platform coverage

Target platforms are `macos-arm64`, `linux-x64` and `linux-arm64`; others are
unsupported.

| Capability | macOS | Linux |
|------------|:-----:|:-----:|
| Mise registry + backends | ✓ | ✓ |
| Bootstrap `brew` formulae | ✓ | ✓ |
| Bootstrap `brew-cask` casks | ✓ | fonts only |
| Bootstrap `nix` (nixpkgs) | ✓ | ✓ |
| Nix profile scope | multi-user | single-user |
| Homebrew prefix | `/opt/homebrew` | `/home/linuxbrew/.linuxbrew` |

The Devbox CLI is retained on macOS only, purely as an entry point for
installing Nix (see [Devbox](#devbox)).

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
(uninstall what is no longer declared) is `mise bootstrap packages prune`.

Only the **`brew-cask`** prune is wired into the `mise:clean` task
(`--manager brew-cask`); it is conservative — it removes only Mise-owned cask
artifacts. The **`brew`** (formula) prune is deliberately *not* wired into any
task: because the Homebrew prefix is shared, a formula prune removes *any*
undeclared formula in it, which would wipe ad-hoc, *untracked* `brew install`s
(the workflow the Homebrew CLI is kept for). Run it by hand
(`mise bootstrap packages prune --manager brew`) only if you truly want
declarative formula removal, and know every formula to keep must first be
declared.

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

## Per-tool Package Managers

Tools with a built-in package manager for their own plugins, extensions or
packs. Each is declared in the chezmoi source where the tool allows it,
installed by a chezmoi script and updated by a `mise run update` subtask:

| Tool | Manager CLI | Declared in | Lockfile | Install hook | Update task |
|------|-------------|-------------|----------|--------------|-------------|
| Yazi | `ya pkg` | `dot_config/yazi/package.toml` | same file | `after_75` → `yazi:install` | `yazi:update` |
| Neovim | lazy.nvim | `dot_config/nvim/lua/` specs | `dot_config/nvim/lazy-lock.json` | `after_62` → `nvim:install` | `nvim:update` |
| nono | `nono pull` | `.chezmoidata/packages.yaml` (`packages.nono`) | untracked (`~/.config/nono/packages/lockfile.json`) | `after_82` | — |
| pi | `pi` | `dot_pi/agent/settings.json` | — | — | `pi:update` |
| Skills | `skills` | `dot_agents/dot_skill-lock.json` | same file | — | `agents:update` |
| Claude Code | `claude plugin` | `private_dot_claude/settings.json` | untracked (`~/.claude/plugins/installed_plugins.json`) | — | — |
| Mise plugins | `mise plugins` | implicit, by plugin backends in `[tools]` | — | `after_10` (`mise install`) | `mise:update` |

Claude Code plugins are changed through the `claude plugin` CLI, which
rewrites `~/.claude/settings.json`; re-add it with `chezmoi re-add` afterwards.

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
