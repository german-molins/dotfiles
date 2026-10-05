# Changelog Review

Runs before the update so the user decides on breaking changes, needed
adaptations and new features while nothing is installed yet. All commands here
are read-only.

## Inventory

List pending upgrades per scope, from `$HOME` unless noted, keeping only the
selected scopes and packages:

| Scope | Command | Reviewed |
|-------|---------|----------|
| mise tools | `mise outdated --json` | yes |
| chezmoi | `chezmoi --version` vs `gh release view -R twpayne/chezmoi --json tagName` | yes |
| pi extensions | `pi list`, then installed `package.json` version vs `npm view <pkg> version` | yes |
| nono | `nono update --dry-run` | yes |
| mise bootstrap | `mise bootstrap packages status` | no, list only |
| skills | `skills check --global` | no, list only |
| apt | `apt list --upgradable` | no, list only |
| yazi, nvim | none: commit-tracked, no releases | no |

`mise outdated` honors `minimum_release_age`, so it lists only eligible
releases. Mark tools declared only in `~/.config/mise/config.local.toml` as
**local**: list them, never review them, since nothing in the repo integrates
with them.

## Triage

Classify each reviewed upgrade by its semver jump and by its integration in the
repo (config files under `home/`, mise tasks, wrappers, aliases, templates,
skills, docs):

- **Full review**: minor or major jumps (a 0.x minor counts as major), and
  patch jumps of integrated tools. Read every release in the jump: breaking
  changes, deprecations, impact on each integration point, notable features.
- **Skim**: patch jumps of tools with no integration point. Every release in
  the jump, breaking changes, deprecations and security fixes only. Batch all
  of them into a single reviewer.

## Reviewers

Spawn at most 6 parallel subagents, grouping full-review tools by domain (e.g.
AI CLIs, language toolchains, git and review tools, one tool family). Each
gets this prompt, filled in:

```text
Review upstream changelogs for pending upgrades in the chezmoi dotfiles repo
at <repo> (source dir `home/`; global mise config
home/dot_config/mise/config.toml; the `backend` field in
home/dot_config/mise/mise.lock names each tool's upstream). READ-ONLY: do not
install, upgrade, edit or commit anything.

Tools: <tool: from → to, depth>

1. Read the release notes of EVERY version in each jump (`gh release view`,
   or CHANGELOG.md via `gh api`).
2. Grep `home/`, `mise/`, `mise.toml`, `.claude/`, `docs/` for every
   integration point of each tool.
3. Cross-reference: what breaks or needs adapting, and which new features
   matter given how the repo uses the tool.

Per tool, under 200 words:
### <tool> <from>→<to>
- Integration points:
- Breaking/deprecations: (with the version that introduced each)
- Adaptation needed in repo: (none | concrete change + file)
- Post-upgrade actions: (none | commands, e.g. daemon restarts)
- Notable new features: (none | 1 line each, why relevant here)
- Sources:
Flag uncertainty explicitly.
```

Spot-check any reviewer claim that drives a decision (an adaptation, a hold,
a feature to adopt) against its source before presenting it.

## Decisions

Present one table, one row per upgrade: jump, breaking or behavior changes,
adaptation needed, post-upgrade actions, notable features. List local and
list-only scopes below it. Then ask in one round:

- **Holds**: upgrades not to take now. Pin each in `config.toml` to its
  current version, with a short comment, in its own commit before the update.
  Unpinning becomes a follow-up.
- **Adaptations**: confirm each; they are applied after the update and folded
  into their scope's commit.
- **Post-upgrade actions**: which to run in Finish.
- **Follow-ups**: features to try, and unpins. Ask whether to track them,
  suggesting the issue tracker the project uses, and file nothing without the
  user's yes.

Keep the table: the delta review and the commit bodies build on it.

## Delta review

After the run, compare the newly locked versions with the table. Versions
past the reviewed ones (releases that became eligible during the run) get the
same triage and review for the missing releases only, before the scope is
committed. A new breaking change holds back that scope and goes to the user.
