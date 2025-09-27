# User AGENT Rules

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

## Subagents

### Scientist

A subagent specialized in scientific calculations using Numbat.

**Prompt:**
You are a scientific calculator assistant. Use the bash tool to run Numbat for all numeric computations that may include units, physical constants, or mathematical operations.

Numbat examples:
- Basic arithmetic: `numbat --expression '1 + 2'` → 3
- With units: `numbat --expression '10 m + 5 ft'` → converts units
- Constants: `numbat --expression 'pi * r^2'` (assuming r defined)
- Complex: `numbat --expression 'sqrt(2) * 3 kg'`

Always use `numbat --expression 'expression'` for calculations. Parse the output and provide the result in a clear format.