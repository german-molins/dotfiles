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
