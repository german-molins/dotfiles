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

## Comparison

| Feature | Amp | Amazon Q Developer |
|---------|-----|-------------------|
| **Context Files** | `@` syntax references | JSON path configuration |
| **Command Restrictions** | Allowlist-based | Security-focused |
| **MCP Support** | Yes | Yes |
| **Context Scope** | Global, subtree and project | Global and project |

Both agents follow the standardized context file structure, making it easy to
share rules and configuration between them while maintaining agent-specific
optimizations.
