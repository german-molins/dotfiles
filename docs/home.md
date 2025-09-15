# Home

## Environment

Environment variables (managed by mise):

| Env Var | Value |
|---|---|
| `EDITOR` | Bare Neovim |
| `VISUAL` | Neovim |

## Home Structure

- `repos/${owner}/${repo}`: Repositories are to be cloned in this directory
hierarchy, where the owner may refer to a user or an organization.
- `sandbox/*/`: Playground for any kind of bounded trial or draft.
- `~/.cache/dotfiles/`: Custom dotfiles caches for performance optimizations
(see e.g. [Bash caching](../tools/bash.md#startup-caching-optimizations)).

## Fonts

### Kitty terminal emulator

Kitty has a built-in NERD font, so no need to configure one.
