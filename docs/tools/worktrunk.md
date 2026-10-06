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

::: warning
This file is not managed by chezmoi yet.
:::

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

3. Write the project hooks, for example:

   ```toml
   # .config/wt.toml
   post-start = "mise x -- npm install"
   pre-remove = "mise daemons stop --local"
   ```

## Gotchas

- `wt switch --create x` branches from the default branch, not the current
  one. Pass `--base` (`--base @` for the current branch) to stack on another.
