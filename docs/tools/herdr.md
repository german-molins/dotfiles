# Herdr

To [keep your local work and remote agents in one Herdr
window](https://herdr.dev/docs/connecting-machines/), add a SSH host like

```sh
herdr machine add workbox --label "Build machine"
```

## Agent Skill

The [herdr skill](https://herdr.dev/docs/agent-skill/) is installed globally
with the [Skills](../agents.md#skills-by-vercel) CLI (`skills add herdrdev/herdr
--skill herdr -g`), so agents in a Herdr pane can inspect and drive other
panes and agents.

## Agent Integrations

`herdr integration install <agent>` installs the hooks or plugins that report
agent state and session references, which Herdr uses to resume agent
conversations after a server restart. The scripts themselves stay unmanaged,
but they are registered in chezmoi-managed files (`~/.claude/settings.json`,
`~/.config/opencode/cli.json`), so add those back after installing.

Herdr upgrades can bump the integration versions: check with `herdr
integration status --outdated-only`, then, from a shell outside Herdr, stop the
server, reinstall the outdated integrations and start it again.
