# Home

## Environment

Environment variables (managed by mise):

| Env Var | Value |
|---|---|
| `EDITOR` | Bare Neovim |
| `VISUAL` | Neovim |

## Home Structure

This repo follows the [XDG Base Directory Specification][xdg-basedir] for
organising dotfiles and runtime data:

| XDG variable        | Default path         | Purpose                          |
|---------------------|----------------------|----------------------------------|
| `XDG_CONFIG_HOME`   | `~/.config`          | User-specific configuration      |
| `XDG_DATA_HOME`     | `~/.local/share`     | User-specific data files         |
| `XDG_STATE_HOME`    | `~/.local/state`     | Persistent application state     |
| `XDG_CACHE_HOME`    | `~/.cache`           | Non-essential cached data        |

The basedir variables are **not** set explicitly — applications fall back to the
defaults per the spec. [XDG user directories][xdg-user-dirs] (`XDG_DESKTOP_DIR`,
`XDG_DOWNLOAD_DIR`, etc.) are declared in `~/.config/user-dirs.dirs` and sourced
by mise so they are available as environment variables.

Additional conventions:

- `repos/${owner}/${repo}`: Repositories are to be cloned in this directory
hierarchy, where the owner may refer to a user or an organization.
- `sandbox/*/`: Playground for any kind of bounded trial or draft.
- `~/.cache/dotfiles/`: Custom dotfiles caches for performance optimizations
(see e.g. [Bash caching](tools/bash.md#startup-caching-optimizations)).

[xdg-basedir]: https://specifications.freedesktop.org/basedir-spec/latest/
[xdg-user-dirs]: https://www.freedesktop.org/wiki/Software/xdg-user-dirs/

## Fonts

### Kitty terminal emulator

Kitty has a built-in NERD font, so no need to configure one.
