# Worktree Workflow

How I set up a repository locally for parallel agents, one git worktree per
task. Everything here is personal and untracked, so teammates who use none of
it keep working with plain npm and their usual tools.

Building blocks:

- [Worktrunk](tools/worktrunk.md): creates worktrees and copies local files
  into them.
- [Mise](tools/mise.md): tools, env, tasks and per-worktree
  [daemons](tools/mise.md#daemons) (on [pitchfork](global_services.md)).
- [aube](tools/aube.md): optional, faster installs for npm repositories.
- [fnox](tools/fnox.md): secrets, with personal overrides in `fnox.local.toml`.
- [Herdr](tools/herdr.md): agent-aware terminal workspaces.
- [Beads](agents.md#beads): issue tracking, opted in per repository.

## Isolated Stack per Worktree

Run the dev stack with `mise daemons`: each worktree gets its own set of
daemons and its own ports, derived from a base port plus a per-worktree offset
([ports across git worktrees](https://mise.jdx.dev/daemons.html#ports-across-git-worktrees)).
Never hardcode ports; `mise daemons urls` shows them.

## Personal Overrides

All untracked, and copied into new worktrees by my
[worktrunk user hooks](tools/worktrunk.md#user-hooks):

- `mise.local.toml`: tools, env, tasks and daemons on top of the project's
  config ([configuration hierarchy](https://mise.jdx.dev/configuration.html#configuration-hierarchy)).
- `CLAUDE.local.md` importing `AGENTS.local.md`: private agent context,
  including the Beads opt-in (see [Context File Usage](agents.md#context-file-usage)).
- `fnox.local.toml`: personal secret sources.

Keep them out of git with `.git/info/exclude` when the project's `.gitignore`
doesn't cover them.

## Tasks

Expose build, test and lint as mise tasks, so agents and humans run the same
commands in any worktree:

- [Monorepo tasks](https://mise.jdx.dev/tasks/monorepo.html#monorepo-tasks)
  and [`dir`](https://mise.jdx.dev/tasks/task-configuration.html#dir) run
  tasks in the right package.
- [Lazy tools](https://mise.jdx.dev/dev-tools/shims.html#lazy-tools) are not
  on a task's `PATH`; install them on demand from the task
  (`mise install <tool>`) or call them through `mise x`.
- [`mise doctor project`](https://mise.jdx.dev/configuration/project-diagnostics.html#check-configuration)
  checks that a worktree is ready (tools, secrets, services).

```toml
# mise.local.toml
[tasks.test]
dir = "{{config_root}}/packages/api"
run = "npm test"
```

## Lifecycle

```sh
wt switch --create fix-login --base main   # copies local files, runs project hooks
mise daemons start core                    # this worktree's stack, own ports
# ... agent works, tests against its own stack ...
wt remove fix-login                        # project hooks stop and prune its daemons
```

The [project lifecycle hooks](tools/worktrunk.md#per-project-lifecycle-hooks)
also drop the worktree's leftover entry in `~/.config/pitchfork/config.toml`;
see [Shared with Mise Daemons](global_services.md#shared-with-mise-daemons).
