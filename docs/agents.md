# Agents

LLM-powered coding and shell assistants that use tools to help with development
tasks.

> [!NOTE]
> [Freebuff](https://freebuff.com) is listed among the agent harnesses but is
> currently uninstallable: its aube package's stale content hash is rejected by
> the registry at every published version. Parked pending an upstream fix or an
> alternative install path.

## Context Files

Agents use standardized context file paths for providing additional context and
rules:

See [specification of `AGENTS.md` files](https://agents.md).

- `~/.config/AGENTS.md` - Global (user) agent context file
- `AGENTS.md` - Local (project) agent configuration. It admits nesting files
for subdirectories.

## MCP Servers

Several Model Context Protocol (MCP)
servers are configured to enhance coding assistants capabilities:

| Name | Type | Protocol | API Key | Description |
|------|------|----------|---------|-------------|
| [Context7] | remote | http | `CONTEXT7_API_KEY` | Up-to-date, version-specific documentation and code examples directly from source repositories |

[Context7]: https://context7.com

## Skills

Standard skills path is adopted as convention

- `~/.agents/skills/` - Global
- `.agents/skills/` - Per project

Symlinks to Claude equivalents are also created automatically by the skills
manager upon installation:

- `~/.claude/skills/` - Global
- `.claude/skills/` - Per project

All assistants I use are compatible with either or both.

### Authored Skills

| Skill | Description |
|-------|-------------|
| numbat | [Numbat] programming language reference for statically typed scientific computations with first-class support for physical dimensions and units. |
| scientific-calculator | High-precision scientific calculator with full support for physical units, dimensional analysis, unit safety, and built-in physical constants. Wraps the `numbat` skill for language reference. Requires `numbat` CLI. |

[Numbat]: https://numbat.dev/docs/

### Skills Managers

These are the skills managers I use, in order of precedence.

#### [Skills](https://skills.sh/) by Vercel

`skills` lets you manage skills across many agentic assistants. It is my
default skills manager.

#### Context7

Similarly, use `ctx7` (Context7 Skills) to manage agents skills:

- `ctx7 skills install`
- `ctx7 skills search`
- `ctx7 skills generate`: Generate skills with the help of AI (requires `ctx7
login`)

## Claude Code

[Claude Code](https://code.claude.com) is Anthropic's official CLI coding agent.

### Plugins

- [Matt Pocock Skills](https://github.com/mattpocock/skills): See [the
documentation](https://www.aihero.dev/skills).
- [Superpowers](https://github.com/obra/superpowers): Complete software
development workflow - disabled by default
- [Beads](https://github.com/gastownhall/beads): Issue tracker for agents -
disabled; opted into per project instead (see [Beads](#beads))
- [Context Mode](https://github.com/mksglu/context-mode): Sandboxed tool
output to protect the context window
- [Ponytail](https://github.com/DietrichGebert/ponytail): Lazy senior developer
mode against over-engineering
- [nono](https://nono.sh): Kernel sandboxing integration; installed and wired
by the `nolabs-ai/claude` nono pack, not a marketplace (see [nono
Packs](package_managers.md#nono-packs))
- [Context7](https://github.com/upstash/context7): Up-to-date library docs -
disabled by default
- [rust-analyzer LSP](https://github.com/anthropics/claude-plugins-official):
Rust language server - disabled by default

### Configuration

- **User Settings**: `~/.claude/settings.json` - defines MCP servers and user preferences
- **User Context**: `~/.claude/CLAUDE.md` - global (user) context file
- **Project Settings**: `.claude/settings.json` - project-specific configuration
- **Project Context**: `.claude/CLAUDE.md` - local (project) context file

### Context File Usage

Claude Code reads context through:

1. Global `~/.claude/CLAUDE.md` file
2. Local `.claude/CLAUDE.md` file in project root
3. Referenced files using `@` syntax

**Note**: While Claude Code uses `CLAUDE.md` as its native context file format,
it can reference the standardized `AGENTS.md` files by including `@~/.config/AGENTS.md`
or `@AGENTS.md` in the respective `CLAUDE.md` files.

Reference: [Claude Code Settings](https://code.claude.com/docs/en/settings)

### Context Window and Compaction

Current models run with a native 1M token window at standard pricing, and
auto-compaction by default fires near the end of it (~967K). The settings
keep the 1M window but compact much earlier:

```json
"autoCompactWindow": 300000
```

The intention is to keep two things apart:

- **How large the session grows.** Long contexts make every turn slower and
  costlier and dilute the model's attention with stale tool output. Compacting
  at 300k bounds that, which was the original reason to avoid 1M.
- **How much the model knows up front.** Claude Code sizes the skill listing
  budget at ~1% of the context window. All skill names are always listed, but
  descriptions that overflow the budget are dropped, least-invoked skills
  first, and a skill without a description rarely auto-triggers.

The previous setting, `CLAUDE_CODE_DISABLE_1M_CONTEXT=1`, achieved the first
by shrinking the whole window to 200k, which also starved the second: the
`chezmoi-sync` skill stopped triggering because its description no longer
fit. The compact window also becomes the window `/context`
reports, so the budget follows it. Measured with `claude -p "/context"`:

| Setting | Window | Skills listing | Per skill |
|---------|--------|----------------|-----------|
| `CLAUDE_CODE_DISABLE_1M_CONTEXT=1` | 200k | 2.4k tokens | names only (<20 tokens) |
| `autoCompactWindow: 300000` | 300k | 7k tokens | full descriptions (60-300 tokens) |

Anthropic sets no threshold, but recommends compacting proactively, since the
model is at its least capable when the window is nearly full, and starting a
new session per task ([session management and 1M
context](https://claude.com/blog/using-claude-code-session-management-and-1m-context),
[best practices](https://code.claude.com/docs/en/best-practices)). The 300k
figure follows community practice. `/autocompact` also sets it (saved per
model), and `CLAUDE_CODE_AUTO_COMPACT_WINDOW` overrides everything for a
one-off run. At 300k all skill
descriptions already fit: raising the window to 400k leaves the listing at
7k tokens.

Run `/context` after adding skills or plugins to check that descriptions still
fit. Disabling unused plugins (e.g. Beads) also frees budget.

Options considered and discarded:

- `skillListingBudgetFraction` (or `SLASH_COMMAND_TOOL_CHAR_BUDGET`): raises the
  budget directly while keeping 200k. Reasonable, but it tunes around a window
  size that no longer reflects the models' defaults.
- `skillOverrides` set to `name-only`/`off` for skills never used: does not
  apply to plugin skills, which are only toggled as a whole plugin.
- `CLAUDE_CODE_MAX_CONTEXT_TOKENS`: only meant for models Claude Code does not
  recognize.

### Beads

The Beads plugin injects `bd prime` through hooks in every session, including
projects without a beads database, and lists its skill and commands in every
session. Instead, it is disabled and projects opt in through their private
context file, with no custom hooks to maintain:

```sh
bd setup claude --print >> AGENTS.local.md
```

- `--print` writes Beads' static Claude template to stdout. The template tells
  the agent to run `bd prime`, the source of truth for the full workflow, so
  the snippet does not go stale when Beads changes its commands.
- Append (`>>`) rather than overwrite when `AGENTS.local.md` already holds
  other private context; regenerate by replacing that part.
- `CLAUDE.local.md` must import it with `@AGENTS.local.md`. Both files are in
  the global gitignore.
- `bd setup claude --global` was discarded: it writes the hooks into the user
  settings, i.e. the plugin's behavior again, now hand-maintained.

### MCP Server Configuration

MCP servers are configured through the `mcp` key in `settings.json` or via the
`claude mcp add` command. The following MCP servers are pre-configured:

- **Context7**: Remote HTTP server for up-to-date documentation
- **Mise**: Local stdio server exposing mise environment information

## This Repository

Setup and workflow for agents working on this dotfiles repository itself, as
opposed to the global setup above that I use for developing other projects.

- `AGENTS.md`: project context and conventions (tracked).
- `AGENTS.local.md`, `CLAUDE.local.md`: private project context (untracked).
- Issue tracking with [beads](https://github.com/gastownhall/beads) (`bd`),
  opted in through `AGENTS.local.md` (see [Beads](#beads)).

### Project Skills

Authored in `.agents/skills/` and symlinked from `.claude/skills/`. Both paths
are excluded by the global gitignore, so project skills are tracked with
`git add -f`.

| Skill | Description |
|-------|-------------|
| update-packages | Upgrades mise itself in its own reviewed cycle, then updates packages, tools, plugins and extensions across every package manager, or only the managers or packages named, and commits the results to the chezmoi source, one `build(<scope>): update packages` commit per manager. |

## References

- [AIHero](https://www.aihero.dev/)
