# Bash

[Bash](https://www.gnu.org/software/bash/) is the interactive shell used in this dotfiles setup.

## Startup Caching Optimizations

To improve shell startup time, two types of caching are implemented for tool activation and completion scripts that generate static or semi-static output.

### Mise-Tailored Caching

Mise has specialized caching due to its per-directory environment hooks:

#### Activation Script Caching

The output of `mise activate bash` is cached to `~/.cache/mise/activate_bash.sh`, avoiding regeneration on every shell start. The cache invalidates when the Mise binary is updated.

#### Hook Environment Caching

`mise hook-env` output is cached per directory to reduce per-prompt latency. Cache keys include the current working directory, invalidating on Mise binary changes.

### General Purpose Caching

Outputs from various tools' init and completion commands are cached to `~/.cache/bash/` using a generic caching function:

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

- Mise caches stored in `~/.cache/mise/`
- General caches stored in `~/.cache/bash/`
- Manual clearing with `_mise_evalcache_clear` (Mise) and `_evalcache_clear` (general)
- Automatic invalidation on tool binary changes

### Disabling Cache for Profiling

To compare bash startup performance with and without caching, set the `DISABLE_BASH_CACHE` environment variable:

```bash
DISABLE_BASH_CACHE=1 bash
```

This will bypass all caching mechanisms and execute commands directly, allowing you to profile the uncached startup time.

These optimizations significantly reduce shell startup time by avoiding repeated computation of static initialization scripts.
