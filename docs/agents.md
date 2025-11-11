# Agents

LLM-powered coding and shell assistants that use tools to help with development
tasks.

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
| [Context7](https://context7.com) | remote | http | `CONTEXT7_API_KEY` | Up-to-date, version-specific documentation and code examples directly from source repositories |
| [Mise MCP](https://mise.jdx.dev/mcp.html) | local | stdio | - | Exposes mise-managed development environment information |

## Amp

[Amp](https://ampcode.com/) is an LLM coding agent with built-in support for
context files.

### Configuration

- **Settings**: `~/.config/amp/settings.json`
- **Context Support**: Built-in support for `AGENTS.md` files and `@` file
prefix syntax to read other files

### Context File Usage

Amp reads context through:

1. Local `AGENTS.md` file in project root
2. Global `~/.config/AGENTS.md` file
3. Subdir `AGENTS.md` files in path of files referenced in thread.
4. Referenced files using `@` syntax.

Reference: [Amp Manual - AGENTS.md](https://ampcode.com/manual#AGENTS.md)

## Amp

[Amp](https://ampcode.com/) is an LLM coding agent with built-in support for
context files.

### Configuration

- **Settings**: `~/.config/amp/settings.json`
- **Context Support**: Built-in support for `AGENTS.md` files and `@` file
prefix syntax to read other files

### Context File Usage

Amp reads context through:

1. Local `AGENTS.md` file in project root
2. Global `~/.config/AGENTS.md` file
3. Subdir `AGENTS.md` files in path of files referenced in thread.
4. Referenced files using `@` syntax.

Reference: [Amp Manual - AGENTS.md](https://ampcode.com/manual#AGENTS.md)

### Free Mode

Amp offers a [free tier](https://ampcode.com/manual#free) that can be activated
with `/mode free`.

## Amazon Q Developer

References:

- [Primary documentation](https://docs.aws.amazon.com/amazonq/latest/qdeveloper-ug/command-line.html)
- [Technical documentation](https://aws.github.io/amazon-q-developer-cli/)

AZQ is AWS's LLM coding agent with CLI interface.

### Configuration

- **Global Context**: `~/.aws/amazonq/global_context.json` - defines the
standardized context file paths.
- **Profiles**: `~/.aws/amazonq/profiles/`
- **MCP Config**: `~/.aws/amazonq/mcp.json`

## Claude Code

[Claude Code](https://code.claude.com) is Anthropic's official CLI coding agent.

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

### MCP Server Configuration

MCP servers are configured through the `mcp` key in `settings.json` or via the
`claude mcp add` command. The following MCP servers are pre-configured:

- **Context7**: Remote HTTP server for up-to-date documentation
- **Mise**: Local stdio server exposing mise environment information
