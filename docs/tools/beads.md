# Beads

[Beads](https://github.com/gastownhall/beads) (`bd`) is an issue tracker for
agents. I use it as a personal layer on top of team repositories that don't
use it: nothing of it is ever committed, and each clone keeps its own issues.

## Install

`bd` is a global mise tool from GitHub releases
(`"github:gastownhall/beads"` in `~/.config/mise/config.toml`). It is not in
the mise registry.

Beads stores its data in [Dolt](https://www.dolthub.com/), but the release
binary has Dolt built in and only needs libc: no `dolt` binary, no server, no
Homebrew. The Homebrew formula depends on `dolt` and `icu4c` for server mode;
machines that installed it earlier can drop it with
`brew uninstall beads dolt icu4c@79` once the mise `bd` is on `PATH`.

## Modes

Two independent choices, both set at `bd init`:

- **Storage: embedded** (the default). Dolt runs in-process and the database
  lives in `.beads/embeddeddolt/`. Writers take turns through a lock file.
  Server modes (`--server`, `--shared-server`) run a `dolt sql-server` instead,
  only useful for many concurrent writers or sharing a database between
  machines or people.
- **Git visibility: stealth** (`--stealth`). Adds `.beads/` to the repository's
  `.git/info/exclude`, so the team repository never sees it.

I use embedded + stealth, with no Dolt remote and no git sync: issues stay
local to each clone and machine.

## Opt In a Repository

```sh
bd init --stealth
bd setup claude --print >> AGENTS.local.md
```

The second command is the agent opt-in, see [Agents: Beads](../agents.md#beads).
None of it is committed:

- `.beads/`: `.git/info/exclude`, written by `--stealth`.
- `AGENTS.local.md`, `CLAUDE.local.md`, `.agents/skills/`: global gitignore
  (`home/dot_gitignore`).

`mise doctor project` checks this repository's database with `bd stats`.

## Worktrees

All git worktrees of a clone share one database, found through the git common
directory, so agents in parallel worktrees see the same issues. Beads does not
follow git branches: there is no database per branch. Dolt history is still
there (`bd history`, `bd diff`).

## Server Mode (Not Used)

Kept as an option in case parallel agents start waiting on the embedded lock.
It combines with stealth: a per-project server keeps its data in `.beads/dolt/`,
and a shared server (`--shared-server`) in `~/.beads/shared-server/`, outside
any repository. `bd` starts the server on demand, so it only needs a `dolt`
binary on `PATH` (`aqua:dolthub/dolt` in mise), not a daemon manager or
Homebrew. An always-on server would be a global [pitchfork](../global_services.md)
daemon or a user-scope `[bootstrap.services]` entry. Existing embedded
databases would need migrating.
