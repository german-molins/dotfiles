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
