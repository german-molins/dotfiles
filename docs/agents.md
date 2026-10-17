# Agents

LLM-powered coding and shell assistants that use tools to help with development
tasks.

## Dotfiles Structure

Agents use standardized context file paths for providing additional context and
rules. See [specification of `AGENTS.md` files](https://agents.md).

- `~/.config/AGENTS.md` - Global (user) agent context file, the single source
of the global rules.
- `~/.AGENTS.md` - Symlink to `~/.config/AGENTS.md`, tailored for
[Codebuff/Freebuff](#codebuff-freebuff), which only reads dot-prefixed context
files in `$HOME`. Claude Code never reads it, so the rules are not loaded
twice. The dot matters: Claude Code does look up a plain `~/AGENTS.md` (and
`~/CLAUDE.md`) as an ancestor of any project under `$HOME`, which would
duplicate the rules it already imports.
- `~/.claude/CLAUDE.md` - Claude Code's global context file, which imports
`~/.config/AGENTS.md` (see [Claude Code](#claude-code)).
- `AGENTS.md` - Local (project) agent configuration. It admits nesting files
for subdirectories.
- `~/.agents/skills/`, `~/.claude/skills/` - Global skills (see
[Skills](#skills)).

## MCP Servers

No MCP servers are configured for the coding agents. Tools that could be MCP
servers are used through their CLI and a skill instead, which costs no context
until needed:

| Name | Used through | API Key | Description |
|------|--------------|---------|-------------|
| [Context7] | `ctx7` CLI and the `find-docs` skill | `CONTEXT7_API_KEY` (fnox) | Up-to-date, version-specific documentation and code examples directly from source repositories |
| [Mise] | `mise` CLI | | Tools, tasks and environment of the current project |
| [Playwright] | `playwright-cli` CLI and the `playwright-cli` skill | | Headless browser automation (see [Browser Automation](#browser-automation)) |

[Context7]: https://context7.com
[Mise]: https://mise.jdx.dev/mcp.html
[Playwright]: https://github.com/microsoft/playwright-cli

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

`ctx7` dropped its `skills` commands in 0.8.0. `ctx7 setup` still installs
Context7's own skills (`find-docs`, `context7-mcp`) for an agent, and `ctx7
library` / `ctx7 docs` query documentation directly.

## Browser Automation

Agents check web UIs in a headless Chromium through
[Playwright CLI](tools/playwright_cli.md): the `playwright-cli` global mise
tool, its skill installed with the skills CLI, and a Chromium build matching
the CLI, downloaded by a chezmoi script (191 MiB per version). The official
Claude Code `playwright` plugin is not used, since it only bundles the
Playwright MCP server.

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

- **User Settings**: `~/.claude/settings.json` - permissions, plugins and user preferences
- **User Context**: `~/.claude/CLAUDE.md` - global (user) context file
- **Project Settings**: `.claude/settings.json` - project-specific configuration
- **Project Context**: `.claude/CLAUDE.md` - local (project) context file

### Context File Usage

Claude Code reads context through:

1. Global `~/.claude/CLAUDE.md` file
2. `CLAUDE.md` or `.claude/CLAUDE.md` in the project root and its ancestors,
plus the private `CLAUDE.local.md`
3. Referenced files using `@` syntax

`AGENTS.md` (or `.claude/AGENTS.md`) is loaded natively, but only as a
fallback: in a directory that also has a `CLAUDE.md` or a `CLAUDE.local.md`,
only those are read. Importing `@AGENTS.md` from them is therefore still
needed, and does not load it twice. `AGENTS.local.md` is never loaded
natively, so it is imported from `CLAUDE.local.md`. The global
`~/.config/AGENTS.md` is never found on its own and is imported from
`~/.claude/CLAUDE.md`.

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

### MCP Servers

No local MCP servers are configured (see [MCP Servers](#mcp-servers)). User
scope servers would be added with `claude mcp add --scope user`, which writes
them to `~/.claude.json`, not to `settings.json`. The Context7 plugin is
disabled in favor of the `find-docs` skill. Remote connectors of the claude.ai
account (Atlassian, Google Drive, etc.) are listed by `claude mcp list` but
managed in claude.ai, not in these dotfiles.

## Codebuff/Freebuff

[Codebuff](https://www.codebuff.com) and [Freebuff](https://freebuff.com) are
the same open source CLI ([CodebuffAI/codebuff]); Freebuff is its free,
ad-supported tier. Both are installed lazily with mise (`codebuff` and
`npm:freebuff`). On first run each downloads its binary to
`~/.config/manicode/`, which also holds the shared `settings.json` and
credentials.

Global configuration equivalent to Claude Code's:

- **Instructions**: reads `~/.AGENTS.md` (or `~/.CLAUDE.md`), hence the
[symlink](#dotfiles-structure) to `~/.config/AGENTS.md`.
- **Skills**: loads `~/.agents/skills/` and `~/.claude/skills/` as is.
- **MCP servers**: `~/.agents/mcp.json` (`{"mcpServers": {...}}`), merged
with per-project `.agents/mcp.json`. Not configured.
- **Custom agents**: TypeScript/JavaScript agent definitions in `~/.agents/`
and per-project `.agents/`.

Limitations:

- The global context file must be dot-prefixed in `$HOME`: `~/AGENTS.md`,
`~/.config/AGENTS.md` and `~/.claude/CLAUDE.md` are not read.
- `@` imports in context files are not expanded; content is injected verbatim.
- No permission rules (allow/ask/deny) or hooks.
- Interactive TUI only, no headless/print mode for scripting.
- Freebuff: models are limited to its free catalog (`/model`), sessions spend
Freebucks from a quota and expire after an hour, and the UI shows ads.
- Configuration under `~/.config/manicode/` is written by the tool itself
(model choice, migrations), so it is not managed by chezmoi.

[CodebuffAI/codebuff]: https://github.com/CodebuffAI/codebuff

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
