---
name: update-all
description: >
  Update all packages, tools, plugins and extensions across every package
  manager of these dotfiles (mise, nvim, yazi, pi, skills, brew, apt, ...) and
  commit the results to the chezmoi source. Use whenever the user asks to
  update, upgrade or refresh everything, their tools, packages, plugins or
  lockfiles, or to run the update task, even if no manager is named.
---

# Update All

Updates every package manager through the aggregate mise task, then syncs
target changes into the chezmoi source (`home/`) and commits them per manager.
Maintenance of the repo itself (project `mise.lock`, project skills) is out of
scope.

Invoke the `chezmoi-sync` skill and follow it for preflight, syncing target
changes back, verification and commits. This skill only adds what is specific
to updates: running the update, the scopes that define the commits, and
anomaly detection.

## 1. Preflight (stop and report on any failure)

- `chezmoi-sync` preflight in **strict mode**. Updates touch files across
  every manager, so pre-existing drift would get mixed into update commits.
- `sudo -n true`: `upt:update` runs apt. If it fails, ask the user to run
  `! sudo -v` and wait.

## 2. Run

- Run `mise run update` from the repo root in the background, logging to the
  scratchpad, e.g. `mise run update > "$SCRATCH/update.log" 2>&1; echo "exit=$?"`.
  Every output line is prefixed with its subtask, e.g. `[nvim:update]`.
- Compare `mise tasks info update` against the scopes table. A subtask missing
  from the table is an anomaly: report it.

## 3. Scopes

Commit order follows the `update` task's dependency order. A scope without
tracked files never produces a commit, but its log output still goes into the
summary.

| Subtask | Tracked files | Commit title |
|---------|---------------|--------------|
| `chezmoi:update` | `home/.chezmoidata/packages.yaml` | `build(chezmoi): update bootstrapped package mise` |
| `mise:update` | `home/dot_config/mise/mise.lock`, `home/dot_config/mise/locks/` | `build(mise): update packages` |
| `yazi:update` | `home/dot_config/yazi/package.toml` | `build(yazi): update packages` |
| `nvim:update` | `home/dot_config/nvim/lazy-lock.json` | `build(nvim): update packages` |
| `pi:update` | `home/dot_pi/agent/settings.json` | `build(pi): update packages` |
| `nono:update` | none | none |
| `brew:update` | none | none |
| `upt:update` | none | none |
| `agents:update` | `home/dot_agents/dot_skill-lock.json` | `build(skills): update packages` |

Notes per scope:

- **chezmoi**: `chezmoi upgrade` upgrades the binary bootstrapped by
  `install.sh` in `~/.local/bin`. chezmoi is deliberately not a mise tool, so
  it keeps working when mise is broken. It tracks no file, so report the
  version change. The commit is for the bootstrap mise version: if
  `mise --version` is newer than `packages.bootstrap.mise.version` in
  `packages.yaml`, bump it (format `vYYYY.M.P`).
- **mise**: `lockfile_platforms` limits locks to macos-arm64, linux-x64 and
  linux-arm64. Churn of `[conda-packages.*]` builds is normal; removal of a
  whole `[[tools.*]]` entry is not. `mise bootstrap packages upgrade` covers
  brew formulae and nix packages declared in `packages.yaml`. These leave no
  lock, so report what they upgraded. A `mise WARN … Run
  \`mise backends switch <tool>\`` means the registry changed a tool's backend:
  report it with the command and do not run it unasked.
- **yazi**: plugin deps from one repo (yazi-rs/plugins) move together to the
  same `rev`. A changed `hash` with an unchanged `rev` is suspicious.
- **nvim**: LazyVim extras must be declared as `{ import = … }` in
  `home/dot_config/nvim/lua/config/lazy.lua`. `:LazyExtras` writes
  `~/.config/nvim/lazyvim.json`, which chezmoi does not manage, so extras
  enabled there are machine-local and a plugin update on another machine
  drops their plugins from the lock. Ignore `[nvim:update] … log |` lines
  when scanning for errors; they quote upstream commit subjects.
- **pi**: pi itself is a mise tool; `settings.json` changes (e.g.
  `lastChangelogVersion`) usually follow a pi version bump in the global lock.
- **brew**: mise bootstrap and the Homebrew CLI share one Cellar, and mise
  writes standard install receipts, so both see the same formulae. `mise:update`
  upgrades the declared ones first; `brew upgrade` then covers ad-hoc formulae
  and dependencies. Declared formulae showing up again in the brew log means
  they were already current or had a newer bottle, not a conflict. It is a
  no-op without brew.
- **upt**: apt output includes `WARNING: apt does not have a stable CLI
  interface`, which is harmless. An OS point release changes templates that
  render the OS version (e.g. `.bashrc.d/35-functions.sh`); those surface as
  pending applies, not commits.
- **agents**: the task needs `--global`: without it, `skills update` run from
  `$HOME` detects project scope and reports "No project skills to update",
  leaving `dot_skill-lock.json` untouched.

## 4. Collect changes

- `chezmoi status`: `MM`/`M ` lines are target files changed by the update,
  i.e. tool-managed state. Add them back one by one (`chezmoi add <target>`).
- ` M`/`R` lines left after adding are pending applies (templates,
  run_onchange scripts), handled in step 7.
- Mise sidecars: reconcile them as described in chezmoi-sync ("Mise
  sidecars"). The added and destroyed sidecar dirs go in the `mise:update`
  commit.

## 5. Detect anomalies

Any hit holds back that scope's commit:

- **Removed packages**: entries present in `HEAD` but missing after the
  update: top-level keys in `lazy-lock.json`, `[[plugin.deps]]` or
  `[[flavor.deps]]` in `package.toml`, `[[tools.*]]` in `mise.lock`,
  entries under `packages` in pi `settings.json`, skills in
  `dot_skill-lock.json`.
- **Downgrades**: any locked version or commit older than before.
- **Errors behind exit 0**: log lines with `ERROR`, `error:`, `failed`,
  `panic` or `conflict`, apart from the harmless lines noted in step 3.
- **Unexpected files**: a changed file that fits no scope in step 3.
- **Missing mise sidecars**: `exists: false` in `mise lock --global --sidecars
  --json` for a `mise.lock` sidecar.

For removals, find the root cause before asking the user. The usual cause is
target state that chezmoi does not manage and that differs across machines
(see the nvim note). The fix is usually to declare it in the chezmoi source,
in its own commit before the scope's update commit.

## 6. Commit

Follow `chezmoi-sync` commit rules with each scope as one concern: one commit
per scope with changes, in table order, using the scope's commit title. Commit
the clean scopes; for a held-back scope, explain the anomaly and ask the user
how to proceed. Body: 1-3 short lines on notable bumps, removals or fixes.

## 7. Finish

- `chezmoi apply`, after all adds, so pending templates and scripts run. Strict
  preflight guarantees nothing unrelated is pending. `chezmoi status` must then
  be empty.
- Run it under a refreshed mise env (`eval "$(mise -C ~ env -s bash)"` first).
  A shell activated before the update still has old install dirs on PATH, and
  run scripts inherit it: e.g. `pypi:` tools get installed under a digest dir
  that a fresh env does not resolve, leaving them reported missing.
- `git status --short`: only files of held-back scopes may remain. Anything
  else is a leftover to report.
- Health: `mise doctor`, `mise ls --missing`,
  `nvim --headless "+Lazy! health" +qa`.

## 8. Summary

Always include these sections, writing "none" when a section is empty:

- **Commits**: hash and title per scope.
- **Removed packages**: every removal, per manager, with its cause. Never
  leave this implicit.
- **Held back / needs decision**: anomalies, conflicts, suspicious signs, and
  what you need from the user.
- **Untracked updates**: what brew, apt (upt), nix and mise bootstrap
  upgraded. They change the system but leave nothing to commit.
- **Health**: results of the step 7 checks.

End by offering to push; state how many commits the branch is ahead of its
upstream.
