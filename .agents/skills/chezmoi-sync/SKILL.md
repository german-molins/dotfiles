---
name: chezmoi-sync
description: >
  Make any change to these dotfiles so that the chezmoi source (`home/`), the
  target (`$HOME`) and git all end up in sync: add, remove, replace or migrate
  tools, plugins, packages and configs, or edit an existing config. Handles
  preflight, where to edit, applying, adding back tool-written files, removing
  leftovers, docs, verification and commits. Use whenever a task touches
  anything chezmoi manages or installs, even when the user only says "remove
  X", "add Y", "switch to Z" or "change this setting" without mentioning
  chezmoi.
---

# Chezmoi Sync

The job is done only when the source, the target and git agree: the change is
applied to `$HOME`, captured in `home/`, documented and committed. The user
should never need to ask for `chezmoi apply` or `chezmoi add` separately.

Work on explicit paths throughout (`chezmoi apply <paths>`, `chezmoi add
<file>`, `git add <paths>`), never blanket commands. Unrelated drift may exist,
and path-scoped commands leave it untouched instead of sweeping it into the
task.

## 1. Preflight

Record the baseline: `git status --short` and `chezmoi status`.

- **Default mode**: if either shows changes, list them and ask the user whether
  to proceed around them. Stop if any of them overlaps the paths the task will
  touch, since the task's result could not be separated from the drift.
- **Strict mode** (when the invoking skill asks for it): both must be clean;
  otherwise report and stop.

## 2. Change

Choose the edit direction per file:

- **Plain config**: edit the source in `home/`, then `chezmoi apply <target>`.
- **Tool-managed state**: whenever a tool has a command that mutates its own
  config, lock or state files, use it on the target instead of hand-editing,
  then `chezmoi add <file>` for each file it changed. Tools keep their related
  files consistent; hand edits do not. Example: mise tools go through `mise use
  -g <tool>` / `mise rm -g <tool>`, because hand-editing `[tools]` in
  `config.toml` leaves orphaned `[[tools.*]]` entries in `mise.lock` and
  `mise.local.lock` that need a slow `mise lock --global` to clean up. The same
  applies to the skills CLI, `Lazy` for `lazy-lock.json`, etc. Settings with no
  CLI (env vars, `[settings]`) are edited in the source.
- **Mise sidecars**: npm and pypi tools keep their native dependency lockfiles
  (aube, uv) in per-version
  [sidecar dirs](https://mise.jdx.dev/dev-tools/mise-lock.html#native-dependency-sidecars)
  under `~/.config/mise/locks/`, which must be managed along with `mise.lock`.
  `mise use`, `upgrade` or `lock` writes the new sidecar dirs, which `chezmoi
  status` does not show while unmanaged, and leaves the old ones behind.
  Sidecars of `mise.local.lock` live under `locks/mise.local/`, are
  machine-local and ignored by chezmoi. After any such command touching npm or
  pypi tools, reconcile:

  ```sh
  cd ~/.config/mise
  mise lock --global --sidecars --json \
      | jq -r '.[] | select(.lockfile == "mise.lock") | .sidecars[]
          | "\(.exists) \(.path)"' >"$SCRATCH/sidecars"
  grep '^false ' "$SCRATCH/sidecars"                       # missing
  cut -d' ' -f2 "$SCRATCH/sidecars" | sort >"$SCRATCH/sidecars-keep"
  find locks -mindepth 2 -maxdepth 2 -type d ! -path 'locks/mise.local/*' \
      | sort | comm -13 "$SCRATCH/sidecars-keep" -         # stale
  ```

  A missing sidecar is an anomaly: report it and stop, do not regenerate it.
  `chezmoi add` each sidecar dir in the keep list (a no-op when unchanged).
  `chezmoi destroy --force` each stale sidecar dir (plain `rm -r` if
  unmanaged), and its `<tool>` parent once empty.
- **Templates** (`*.tmpl`): always edit the source template; `chezmoi add` would
  strip the template attribute and store rendered output.
- **Removing a managed file**: `chezmoi destroy <target>` (removes it from
  source, target and state). Removing a file from `home/` alone leaves it
  behind in `$HOME`.

Also look for references elsewhere in the source that the change affects
(imports, lists of plugins or extras, lock entries, other tools' configs) and
update them.

## 3. Leftovers outside chezmoi

Additions and removals often involve state chezmoi does not manage: installed
plugins (`~/.local/share/nvim/lazy`), mason packages, caches, tool data dirs
(`~/.config/<tool>`, `~/.<tool>`). For removals, search `$HOME`'s usual
locations for the tool's name.

- Plugins, packages and caches: remove them, preferably with the owning tool
  (e.g. `nvim --headless "+Lazy! clean" +qa`).
- Credentials, auth tokens or user data: list them and ask before deleting;
  they cannot be recovered.

## 4. Docs

Update pages under `docs/` that mention what changed, and remove stale
instructions. Also consider whether the change introduces something worth
documenting that is not documented yet (a new tool, a non-obvious setting, a
caveat found during the task), and add it.

## 5. Verify

- `chezmoi status <paths>` is empty for every touched target.
- Path-scoped applies skip `run_onchange_` scripts that hash the touched files
  (e.g. nvim package install on `lazy-lock.json` changes). Check `chezmoi
  status` for new `R` lines not in the preflight baseline and run them with
  `chezmoi apply ~/.chezmoiscripts/<name>`.
- For removals, grepping the repo (excluding `.git`) and the relevant target
  locations for the name finds nothing unexpected.
- When the affected app has a cheap smoke check, run it, e.g. `nvim --headless
  +qa` with no errors or `<tool> --version`.
- `git status --short` shows only the task's files plus the preflight baseline.

## 6. Commit

Conventional commits (`<type>(<scope>): <description>`, max 72 characters,
imperative), with a body explaining what changed and why, including the
target-side cleanup that the diff cannot show. One commit per concern: split
unrelated parts (e.g. removing one plugin, then another that depended on it)
into separate commits, staging only their paths. An invoking skill may define
the concerns and their order. Include each concern's docs in its commit.

Never push; offer it at the end.
