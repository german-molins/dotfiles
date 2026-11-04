# User AGENT Rules

## Tools

- When you need to search docs, use `context7` tools.

## Development Environment

- Runtime, environment and tasks manager: `mise`

### Commands

- List all tasks: `mise tasks --extended`
- List project tasks: `mise tasks --local --extended`

## Code Style

- NEVER write code comments except very rarely for very nuanced clarifications.
- Unless otherwise stated, ALWAYS write shell scripts to be POSIX and using
shebang `#!/usr/bin/env sh`.

## Git Workflow

- ALWAYS use conventional commits with comprehensive title and detailed body.

## Untracked Artifacts

- Write throwaway intermediates to the session scratchpad or `/tmp`.
- Write anything worth inspecting later (scripts you may rerun,
test/benchmark logs, generated data, results) under `.run/<topic>/` in the
project root, never committed.
