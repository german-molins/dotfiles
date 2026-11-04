# [Jujutsu](https://jj-vcs.github.io/jj/)

Jujutsu (jj) is a Git-compatible version control system.

## Aliases

### `update-time`

Updates author timestamps for commits between a branch's origin and its local tip:

```sh
jj update-time <branch>
```

## Colocated Workspaces

Every workspace, not just the default one, can be colocated: `jj workspace add`
creates a Git worktree alongside it (`--[no-]colocate`, setting
`git.colocate`), so Git-based tools like [Worktrunk](worktrunk.md) see it.
`jj git colocation enable`/`disable` toggles it later. See
[Colocated Jujutsu/Git workspaces](https://jj-vcs.github.io/jj/latest/git-compatibility/#colocated-jujutsugit-repos).
Not part of my [worktree workflow](../worktree_workflow.md) yet.
