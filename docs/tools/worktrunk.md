# Worktrunk

[Worktrunk](https://worktrunk.dev) (`wt`) manages git worktrees for parallel
agents. This page covers how I use it on repositories whose team doesn't, so
everything stays local and untracked. See [Worktree Workflow](../worktree_workflow.md)
for the whole setup.

## Configuration

There are two config files
([user](https://worktrunk.dev/config/#user-configuration) and
[project](https://worktrunk.dev/config/#project-configuration)):

- `~/.config/worktrunk/config.toml`: my hooks for every repository.
- `.config/wt.toml` in the repository: hooks of that project.

Points worth knowing about [hooks](https://worktrunk.dev/hook/#hook-types):

- `pre-*` hooks block and abort on failure; `post-*` hooks run in the
  background with their output in log files.
- User `pre-*` hooks [run before the project's](https://worktrunk.dev/hook/#project-vs-user-hooks),
  so a user `pre-start` hook can prepare files that project hooks need.
  `post-*` hooks of both sources start together and don't wait for each other.
- Project hooks need [approval](https://worktrunk.dev/config/#wt-config-approvals--how-approvals-work)
  the first time they run, and again whenever they change.

## User Hooks

```toml
# ~/.config/worktrunk/config.toml
[pre-start]
local-files = '''
src="{{ primary_worktree_path }}"
for f in mise.local.toml mise.local.lock AGENTS.local.md CLAUDE.local.md fnox.local.toml; do
  if [ -e "$src/$f" ] && [ ! -e "$f" ]; then cp --reflink=auto "$src/$f" "$f"; fi
done
'''
copy-ignored = "wt step copy-ignored --require-include"
```

- `local-files` copies my personal, untracked overrides from the primary
  worktree, in every repository.
- `copy-ignored` copies the gitignored files listed in `.worktreeinclude`, and
  only in repositories that have one.

## Copying Ignored Files

[`wt step copy-ignored`](https://worktrunk.dev/step/#wt-step-copy-ignored)
copies the gitignored files that match `.worktreeinclude`
([what gets copied](https://worktrunk.dev/step/#wt-step-copy-ignored--what-gets-copied),
[copying untracked files](https://worktrunk.dev/hook/#copying-untracked-files)).
Copies are reflinks where the filesystem supports them: on btrfs and APFS they
take no extra disk space until modified, on ext4 they are full copies.

## Untracked Project Hooks

When the team doesn't use worktrunk, keep the project hooks untracked too:

1. Ignore both files locally in `.git/info/exclude`:

   ```text
   .config/wt.toml
   .worktreeinclude
   ```

2. List the hooks file in `.worktreeinclude`, so the user `copy-ignored` hook
   brings it into every new worktree before the project hooks run:

   ```text
   .config/wt.toml
   .worktreeinclude
   ```

3. Write the project hooks in `.config/wt.toml`, for example the
   [lifecycle hooks](#per-project-lifecycle-hooks) below.

## Per-Project Lifecycle Hooks

Hooks that install dependencies on create and tear down a worktree's
[mise daemons](mise.md#daemons) on remove. They are project config
(`.config/wt.toml`, kept untracked as above), not user config, because they
only make sense where the project defines `mise daemons` and an install step:

```toml
# .config/wt.toml
pre-start = "mise x -- npm install --no-save"
pre-remove = "if mise daemons ls | grep -qvw available; then mise daemons stop; fi"
post-remove = '''
mise daemons prune --yes && pitchfork clean --prune || exit
f=~/.config/pitchfork/config.toml
awk '
  BEGIN { RS = ""; ORS = "" }
  /^\[namespaces\./ && !/\nconfig = / && match($0, /\ndir = "[^"]*"/) {
    if (system("test -d \"" substr($0, RSTART + 8, RLENGTH - 9) "\"")) next
  }
  { print (n++ ? "\n\n" : "") $0 }
  END { print "\n" }
' "$f" > "$f.tmp" && mv "$f.tmp" "$f"
'''
```

- `pre-start` installs dependencies, here with npm; use the project's install
  command. It is `pre-` so it blocks: user `pre-start` hooks (which copy local
  files) run first, and a `post-start` install would run in the background,
  racing with whatever comes next, such as an immediate `git merge`.
  `--no-save` because a plain `npm install` over copied `node_modules` strips
  other platforms' optional dependencies from `package-lock.json` once the lock
  changes.
- `pre-remove` stops the worktree's daemons while it still exists, and only if
  any is running.
- `post-remove` runs in the primary worktree once the removed one is gone,
  which is when [`mise daemons prune`](https://mise.jdx.dev/daemons.html#pruning-deleted-projects)
  can see it as deleted. The `awk` filter then drops the `[namespaces.*]`
  entries prune leaves behind: only those without a `config =` line whose `dir`
  no longer exists. See
  [Shared with Mise Daemons](../global_services.md#shared-with-mise-daemons)
  for what prune and `pitchfork clean` do and don't remove.

## Gotchas

- `wt switch --create x` branches from the default branch, not the current
  one. Pass `--base` (`--base @` for the current branch) to stack on another.
