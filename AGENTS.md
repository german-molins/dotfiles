# Development Guide

## Build/Test/Lint Commands

- **Documentation dev server**: `mise docs:dev` or `bun run docs:dev`
- **Build documentation**: `mise docs:build` or `bun run docs:build`
- **Generate docs**: `mise docs:generate` (generates both mise and devbox docs)
- **Preview built docs**: `bun run docs:preview`
- **Check health**: `mise check-health` (system health checks)

## Architecture & Structure

- **Chezmoi-managed dotfiles**: All configs in `home/` directory with `dot_`
prefix
- **VitePress documentation**: `docs/` directory with auto-generated content
- **Mise tasks**: `mise/` directory for automation and build tasks
- **Package managers**: Mise (primary), Devbox, Homebrew, Nix for different use
cases
- **Profile-based config**: Uses `DOTFILES_PROFILE` for personal or work
environments
- **Modular bash**: `home/dot_bashrc.d/NN-name.sh` numbered 10-90 for load
order

## Code Style & Conventions

- **Bash scripts**: 4-space indentation, `shfmt` formatting, snake_case
functions
- **Chezmoi files**: Use `dot_` prefix, `private_dot_config/` for sensitive
configs
- **Git commits**: Conventional commits format: `<type>: <description>` (fix,
feat, build, chore, ci, docs, style, refactor, perf, test)
- **Commit messages**: Max 72 characters, imperative mood, detailed body when
needed
- **Python code**: Type hints everywhere, pathlib for paths, sphinx-style
docstrings
- **File organization**: Numeric prefixes for load order, template-driven
configuration
