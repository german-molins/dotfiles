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
conversations after a server restart. The scripts themselves stay unmanaged.
Codex, pi and omp register them in unmanaged files, opencode in the managed
`~/.config/opencode/cli.json` with a relative path, and Claude Code in the
managed `~/.claude/settings.json` with an absolute path.

That absolute path is this machine's home, and herdr only recognizes its hook
by that exact string, so a committed path would add a second hook on every
other machine. The managed file therefore uses `"$HOME/..."`, and
`mise run herdr:integrations` puts it back after each install: it rewrites
every Claude hook command under the home directory to `$HOME` and drops the
duplicate, keeping the entry herdr just wrote.

On each machine, after a herdr upgrade:

1. `mise run herdr:integrations` reinstalls the outdated integrations
   (`herdr integration status --outdated-only`) and normalizes the Claude
   hooks. Pass agent names to install those instead, e.g. on a new machine.
2. Check the `chezmoi status` it prints; a change left there is herdr's own
   (e.g. a new hook matcher), to add back with `chezmoi add`.
3. New integrations load in a new server, which kills every pane process.
   Agents with an integration resume their sessions; save editors and other
   work first. From a shell outside Herdr, `herdr server stop`, then `herdr`.
