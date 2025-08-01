# Agents

LLM-powered coding and shell assistants that use tools to help with development
tasks.

## Context Files

Agents use standardized context file paths for providing additional context and
rules:

See [specification of `AGENT.md` files](https://ampcode.com/AGENT.md).

### Absolute Paths (Global)

- `~/.config/AGENT.md` - Global agent configuration
- `~/.config/agent/**/*.md` - Global agent rules and context files

### Relative Paths (Project)

- `AGENT.md` - Project-specific agent configuration
- `.agent/**/*.md` - Project-specific agent rules and context files

## Amp

[Amp](https://ampcode.com/) is an LLM coding agent with built-in support for
context files.

### Configuration

- **Settings**: `~/.config/amp/settings.json`
- **Context Support**: Built-in support for `AGENT.md` files and `@` file
prefix syntax to read other files

### Context File Usage

Amp reads context through:

1. Local `AGENT.md` file in project root
2. Global `~/.config/AGENT.md` file
3. Referenced files using `@` syntax (e.g., `@~/.config/agent/git.md`)

Reference: [Amp Manual - AGENT.md](https://ampcode.com/manual#AGENT.md)

## Amazon Q Developer

[Amazon Q Developer](https://docs.aws.amazon.com/amazonq/latest/qdeveloper-ug/)
is AWS's LLM coding agent with CLI interface.

### Configuration

- **Global Context**: `~/.aws/amazonq/global_context.json` - defines the
standardized context file paths.
- **Rules Directory**: `~/.aws/amazonq/rules/`
- **Profiles**: `~/.aws/amazonq/profiles/`
- **MCP Config**: `~/.aws/amazonq/mcp.json`

### Context Files

Besides the shared context files, Amazon Q automatically includes context from:

1. Amazon Q specific rules (`~/.aws/amazonq/rules/**/*.md`)
2. Project-specific files (`.amazonq/rules/**/*.md`)
3. Project documentation (`README.md`)

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
