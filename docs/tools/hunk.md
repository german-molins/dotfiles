# [Hunk](https://hunk.dev)

Terminal diff viewer for agent-authored changesets (`hunk diff`, `hunk show`,
`hunk log`, `hunk gh`, ...). Since
[0.24](https://www.hunk.dev/changelog/0.24/) it also browses a repository
without any diff.

## Browsing files and directories

`hunk open [path]` views a complete file or browses a directory (default `.`)
with a directory tree sidebar:

```sh
hunk open                      # browse the current directory
hunk open src/                 # browse a subdirectory
hunk open README.md            # view one complete file
hunk open --no-sidebar --wrap docs/index.md
```

Options: `--sidebar`/`--no-sidebar`, `--line-numbers`/`--no-line-numbers`,
`--wrap`/`--no-wrap`, `-x, --tab-width <columns>`, `--theme <theme>`.

## Workspace status

`hunk status` opens a live view of the current workspace and its sibling
worktrees, handy to watch what parallel agents are changing. `--static` prints
it once and `--json` emits it for scripts.
