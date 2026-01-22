# Bash

[Bash](https://www.gnu.org/software/bash/) is the interactive shell used in this dotfiles setup.

## Startup Caching Optimizations

To improve shell startup time, caching is implemented for tool activation and
completion scripts that generate static or semi-static output.

### Mise Caching

Mise provides built-in environment caching via `mise activate bash`. See
[mise#7761](https://github.com/jdx/mise/pull/7761) for details.

### General Purpose Caching

Outputs from various tools' init and completion commands are cached to
`~/.cache/dotfiles/bash/` using a generic caching function:

- `zoxide init bash --cmd cd`
- `atuin init bash`
- `usage --completions bash`
- `zellij setup --generate-completion bash`
- `carapace _carapace`
- `devbox global shellenv --init-hook` (if enabled)
- `devbox completion bash` (if enabled)
- `direnv hook bash` (if enabled)
- Homebrew bash completion script

### Cache Management

- General caches stored in `~/.cache/dotfiles/bash/`
- Manual clearing with `_evalcache_clear`
- Automatic invalidation on tool binary changes

### Disabling Cache for Profiling

To compare bash startup performance with and without caching, set the `DISABLE_BASH_CACHE` environment variable:

```bash
DISABLE_BASH_CACHE=1 bash
```

This will bypass all caching mechanisms and execute commands directly, allowing you to profile the uncached startup time.

These optimizations significantly reduce shell startup time by avoiding repeated computation of static initialization scripts.
