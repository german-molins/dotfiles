---
name: update-packages
description: >
  Update packages, tools, plugins and extensions across the package managers
  of these dotfiles (mise, nvim, yazi, pi, skills, brew, apt, ...), either all
  of them, some managers, or named packages, and commit the results to the
  chezmoi source. Use whenever the user asks to update, upgrade or refresh
  everything, a manager, a specific tool or plugin, or lockfiles, or to run
  the update task, even if no manager is named.
---

# Update Packages

Updates every package manager through the aggregate mise task, or a selection
of them, then syncs target changes into the chezmoi source (`home/`) and
commits them per manager.
Maintenance of the repo itself (project `mise.lock`, project skills) is out of
scope.

Invoke the `chezmoi-sync` skill and follow it for preflight, syncing target
changes back, verification and commits. This skill only adds what is specific
to updates: reviewing changelogs, running the update, the scopes that define
the commits, and anomaly detection.

## Selection

Without arguments, everything is updated. Otherwise each argument is a scope
(a subtask name without `:update`, e.g. `mise`, `nvim`), meaning the whole
scope, or a package of one scope (e.g. `hunk`, `snacks.nvim`). `scope:pkg`
(e.g. `mise:pi`) forces the package reading. Resolve every name against the
scopes and their installed packages first; ask the user about names that
match more than one, or none.

A selection narrows every step to the selected scopes and packages: preflight,
review inventory, run, collect, commit and finish. Steps below note how.

## 1. Preflight (stop and report on any failure)

- `chezmoi-sync` preflight in **strict mode**. Updates touch files across
  every manager, so pre-existing drift would get mixed into update commits.
  With a selection, only drift in the selected scopes' tracked files, and in
  targets their changes would re-render, blocks; list any other drift in the
  summary and leave it alone.
- `sudo -n true`, when `upt` is selected: `upt:update` runs apt. If it fails, ask the user to run
  `! sudo -v` and wait.

## 2. Review

Follow [references/review.md](references/review.md): inventory pending
upgrades, review their changelogs and settle the user's decisions before
anything is installed. Skip this step only when the user asks for a quick run
or no review.

## 3. Run

- Run `mise run update` from the repo root in the background, logging to the
  scratchpad, e.g. `mise run update > "$SCRATCH/update.log" 2>&1; echo "exit=$?"`.
  Every output line is prefixed with its subtask, e.g. `[nvim:update]`.
- Compare `mise tasks info update` against the scopes table. A subtask missing
  from the table is an anomaly: report it.
- With a selection, run instead, in table order, `mise run <scope>:update` for
  each whole scope and the scope's package command, with all its selected
  packages at once, for packages.

## 4. Scopes

Commit order follows the `update` task's dependency order. A scope without
tracked files never produces a commit, but its log output still goes into the
summary.

| Subtask | Tracked files | Commit title | Package command |
|---------|---------------|--------------|-----------------|
| `chezmoi:update` | `home/.chezmoidata/packages.yaml` | `build(chezmoi): update bootstrapped package mise` | none: whole scope |
| `mise:update` | `home/dot_config/mise/mise.lock`, `home/dot_config/mise/locks/` | `build(mise): update packages` | `mise upgrade <tool>…`; bootstrap: `mise bootstrap packages upgrade <manager:pkg>…` |
| `yazi:update` | `home/dot_config/yazi/package.toml` | `build(yazi): update packages` | `ya pkg upgrade <id>…` |
| `nvim:update` | `home/dot_config/nvim/lazy-lock.json` | `build(nvim): update packages` | `nvim --headless '+Lazy! update <plugin>…' +qa` |
| `pi:update` | `home/dot_pi/agent/settings.json` | `build(pi): update packages` | `pi update --extension <source>` |
| `nono:update` | none | none | `nono update <namespace/name>` |
| `brew:update` | none | none | `brew upgrade <formula>…` |
| `upt:update` | none | none | `upt update`, then `upt upgrade <pkg>…` |
| `agents:update` | `home/dot_agents/dot_skill-lock.json` | `build(skills): update packages` | `skills update --global --yes <skill>…` |

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

## 5. Collect changes

- `chezmoi status`: `MM`/`M ` lines are target files changed by the update,
  i.e. tool-managed state. Add them back one by one (`chezmoi add <target>`).
- ` M`/`R` lines left after adding are pending applies (templates,
  run_onchange scripts), handled in step 8.
- Mise sidecars: reconcile them as described in chezmoi-sync ("Mise
  sidecars"). The added and destroyed sidecar dirs go in the `mise:update`
  commit.

## 6. Detect anomalies

Any hit holds back that scope's commit:

- **Removed packages**: entries present in `HEAD` but missing after the
  update: top-level keys in `lazy-lock.json`, `[[plugin.deps]]` or
  `[[flavor.deps]]` in `package.toml`, `[[tools.*]]` in `mise.lock`,
  entries under `packages` in pi `settings.json`, skills in
  `dot_skill-lock.json`.
- **Downgrades**: any locked version or commit older than before.
- **Errors behind exit 0**: log lines with `ERROR`, `error:`, `failed`,
  `panic` or `conflict`, apart from the harmless lines noted in step 4.
- **Unexpected files**: a changed file that fits no scope in step 4.
- **Missing mise sidecars**: `exists: false` in `mise lock --global --sidecars
  --json` for a `mise.lock` sidecar.
- **Unreviewed versions**: locked versions past the review table; run the
  delta review in [references/review.md](references/review.md).

For removals, find the root cause before asking the user. The usual cause is
target state that chezmoi does not manage and that differs across machines
(see the nvim note). The fix is usually to declare it in the chezmoi source,
in its own commit before the scope's update commit.

## 7. Commit

Follow `chezmoi-sync` commit rules with each scope as one concern: one commit
per scope with changes, in table order, using the scope's commit title. When
only named packages of a scope were updated, name them in the title instead of
`packages` (e.g. `build(mise): update hunk, gh-stack`), up to 3; beyond that
keep the generic title and list them in the body. Commit
the clean scopes; for a held-back scope, explain the anomaly and ask the user
how to proceed. Apply the confirmed adaptations of a scope before committing
it and fold them into its commit, so every commit is a working state. Body:
1-3 short lines on notable bumps, breaking or behavior changes, adaptations,
removals or fixes.

## 8. Finish

- `chezmoi apply`, after all adds, so pending templates and scripts run. Strict
  preflight guarantees nothing unrelated is pending. `chezmoi status` must then
  be empty. With a selection, apply only the selected scopes' pending targets
  (`chezmoi apply <target>…`); only the drift listed at preflight may remain.
- Run it under a refreshed mise env (`eval "$(mise -C ~ env -s bash)"` first).
  A shell activated before the update still has old install dirs on PATH, and
  run scripts inherit it: e.g. `pypi:` tools get installed under a digest dir
  that a fresh env does not resolve, leaving them reported missing.
- `git status --short`: only files of held-back scopes may remain. Anything
  else is a leftover to report.
- Run the post-upgrade actions approved in the review.
- Health: `mise doctor`, `mise ls --missing`,
  `nvim --headless "+Lazy! health" +qa`.

## 9. Summary

Always include these sections, writing "none" when a section is empty:

- **Commits**: hash and title per scope.
- **Removed packages**: every removal, per manager, with its cause. Never
  leave this implicit.
- **Held back / needs decision**: anomalies, conflicts, suspicious signs, and
  what you need from the user. With a selection, also the unrelated drift left
  alone.
- **Untracked updates**: what brew, apt (upt), nix and mise bootstrap
  upgraded. They change the system but leave nothing to commit.
- **Health**: results of the step 8 checks.
- **Follow-ups**: what the user chose to track from the review, and where.

End by offering to push; state how many commits the branch is ahead of its
upstream.
