# Untracked Artifacts

Where scripts, test runs and generated output go when they should not be
committed: the project-local `.run/` directory, or `/tmp`.

## `.run/`

Project-local directory for untracked run artifacts: scratch scripts, trials,
live and integration test runs, generated data, results and logs. Each run
goes in its own subdirectory, e.g. `.run/<topic>/`. It is ignored in every
repository by the global gitignore (`home/dot_gitignore`).

It lives in the project rather than `/tmp` because its contents are meant to
persist: they survive reboots and `tmp` cleanup, stay next to the code that
produced them, and can be inspected or compared later. It is never committed;
promote anything worth keeping into the tracked tree explicitly.

## `/tmp` vs `.run/`

The question to ask is whether anyone will look at the output again after the
command finishes.

**`/tmp`: disposable, nobody looks at it again**

- Intermediate files used inside one pipeline or script (`mktemp`, sorted
  lists to `comm`, diff inputs).
- Output you read once and throw away, like a quick `--help` dump or a probe
  of what a command prints.
- Downloads or extracted archives you only inspect before deciding something.
- Sockets, lock files, PID files, FIFOs.
- Secrets or decrypted material, where it's a plus that it disappears and
  never ends up near a repo.
- Work that doesn't belong to any project (exploring a system tool, testing in
  a throwaway `git init`).
- Large data you can regenerate cheaply, where keeping it would just bloat the
  project directory.

**`.run/`: results someone may come back to**

- Test or benchmark runs whose logs you'll compare across attempts.
- Scripts an agent wrote that you might run again or tweak.
- Generated datasets, reports, plots, profiling output.
- Live or integration test results against real services.
- Anything that took a while to produce, or that you'd mention later in a PR
  or issue.

Short version: if it's an input or an intermediate step, use `/tmp`. If it's a
result, use `.run/`. When unsure, pick `.run/`, because deleting something
later is cheap and losing a result isn't.

## Agents

The global `AGENTS.md` (`home/dot_config/AGENTS.md`) tells agents to follow
this split. Claude Code sessions already get a per-session scratchpad under
`/tmp/claude-*`, which covers the `/tmp` cases.
