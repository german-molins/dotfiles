# Project Skills

Agent skills for working on this repository. They hold the procedures that
keep the chezmoi source (`home/`), the target (`$HOME`) and git in sync, so an
agent can be asked for an outcome ("remove X", "update everything") instead of
being walked through the commands.

They are authored in `.agents/skills/` and symlinked from `.claude/skills/`.
Both paths are excluded by the global gitignore, so they are tracked with
`git add -f`. See [Agents](agents.md#this-repository) for the rest of the
agent setup of this repository.

| Skill | Use it to |
|-------|-----------|
| [chezmoi-sync](#chezmoi-sync) | Change anything chezmoi manages or installs |
| [update-packages](#update-packages) | Update mise and every package manager, or some of them |

## chezmoi-sync

### When

Any change under `home/`, or to something chezmoi installs: adding, removing,
replacing or migrating a tool, plugin, package or config, or editing a
setting. It triggers on plain requests like "add Y", "remove X" or "switch to
Z", without mentioning chezmoi.

### How

Ask for the change; the skill decides whether to edit the source and apply, or
let the tool write its own state and add it back. A task is done only when the
change is applied, captured in `home/`, documented under `docs/` and committed,
so there is no need to ask for `chezmoi apply` or `chezmoi add` separately.

It works on explicit paths and leaves unrelated drift alone: if the working
tree or `chezmoi status` is not clean, it asks whether to proceed around it,
and stops when the drift overlaps the task.

## update-packages

### When

Updating mise itself and the packages, tools, plugins and extensions of every
package manager (mise, nvim, yazi, pi, skills, brew, apt, ...), or refreshing
lockfiles. It wraps `mise run update` (see
[Updates](package_managers.md#updates)) with changelog review, anomaly
detection and per-manager commits.

### How

- `/update-packages`: everything.
- `/update-packages nvim yazi`: whole scopes, named after their `<scope>:update`
  subtask.
- `/update-packages hunk snacks.nvim`: single packages; `mise:pi` forces the
  package reading of an ambiguous name. `mise-self` selects only the mise
  self-update.

Start from a clean tree: the skill runs `chezmoi-sync` in strict mode, so any
drift in the selected scopes stops it. Expect a few questions on the way:

- **Lazy tools**: whether to install the [lazy tools](tools/mise.md#lazy-tools)
  this machine never used, so they get upgraded from now on.
- **mise release**: decided on its own before any package, since a new mise
  can change the update process.
- **Decisions**: one table of pending upgrades with breaking changes and needed
  adaptations; you choose holds, adaptations, post-upgrade actions and
  follow-ups.
- **Held-back scopes**: removals, downgrades, errors or new health issues
  block that scope's commit until you decide.

It ends with one `build(<scope>): update packages` commit per manager and a
summary of commits, removals, held-back scopes, untracked upgrades (brew, apt,
nix) and health against the baseline. Pushing is left to you.

```d2
:::config
scale: 0.65
:::

direction: down

start: "/update-packages [scopes | packages]"

preflight: Preflight {
  tooltip: clean tree, sudo for apt, health baseline
}
lazy: Uninstalled lazy tools? {shape: diamond}
install: Install them {style.stroke-dash: 3}

newmise: Newer mise? {shape: diamond}
cycle: mise cycle {
  tooltip: review, self-update, commit
}
affects: Affects the update process? {shape: diamond}

review: Changelog review
decisions: Decisions {shape: page}
run: Run update tasks
collect: Collect changes into home/
anomalies: Anomalies? {shape: diamond}
hold: Hold back scope {shape: page}
commit: Commit per scope
finish: Apply, health check, summary

user: You {shape: person}

start -> preflight -> lazy
lazy -> install: yes, if accepted
lazy -> newmise: no
install -> newmise
newmise -> cycle: yes
newmise -> review: no
cycle -> affects
affects -> review: no
affects -> user: yes, stop and ask
review -> decisions
user -> decisions: holds, adaptations, follow-ups
decisions -> run -> collect -> anomalies
anomalies -> commit: clean scopes
anomalies -> hold: affected scopes
hold -> user
commit -> finish
```
