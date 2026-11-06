# [nono](https://nono.sh)

Capability-based kernel sandbox for AI agents. Installed globally by mise
(`nono = "latest"`). Upstream docs: [nono.sh/docs](https://nono.sh/docs).

## Running Claude Code sandboxed

The `claude-nono` mise alias runs Claude Code inside the sandbox with the
`claude-dotfiles` profile and access to the current directory.

The `claude-dotfiles` profile (`~/.config/nono/profiles/claude-dotfiles.json`)
extends the `nolabs-ai/claude` pack profile, grants read-write access to the
working directory and read access to `~/.local/share/mise/installs`, so
mise-managed tools keep working inside the sandbox.

Use `nono why` to check why a path, network host or command is allowed or
denied, and `nono ps` / `nono logs` / `nono audit` to inspect sessions.

## Packs

Packs are signed bundles of profiles and agent integrations, published on the
[nono registry](https://registry.nono.sh/). Browse it there or with
`nono search <query>`; `nono pull`, `nono list`, `nono outdated` and
`nono update` manage installed ones.

Installed packs are declared in `packages.nono` and kept in sync by chezmoi;
see [nono Packs](../package_managers.md#nono-packs). The `nono:update` mise task
(part of the global update) runs `nono update`.
