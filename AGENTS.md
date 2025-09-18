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

## Mise Configuration

This repository uses Mise as the primary package and environment manager. There are two distinct Mise configurations to avoid confusion:

### Local Mise Configuration (Project)

- **Location**: `mise.toml` in the repository root
- **Purpose**: Manages tools and tasks specific to this dotfiles project
- **Tasks**: Documentation generation, build tasks
- **Terminology**: Referred to as "local" mise config

### Global Mise Configuration (System)

- **Location**: `home/private_dot_config/mise/config.toml` (Chezmoi source directory)
- **Purpose**: Manages user-wide tools and environments
- **Tools**: Extensive list of CLI tools, editors, and utilities
- **Environments**:
  - `devbox`: Packages using `mise-nix` backend (Nixhub registry)
  - `opt`: Optional/heavy packages
- **Activation**: Controlled by `MISE_ENV` environment variable (default: "devbox,opt")
- **Terminology**: Referred to as "global" mise config

For more details on Mise, see [docs/tools/mise.md](docs/tools/mise.md).

## Dotfiles Repository Structure

- **Chezmoi Source Directory**: `home/` contains all typical configuration
files.
- **Chezmoi Target Directory**: Files are applied to `$HOME` by Chezmoi

**Important**: When discussing changes to configuration files, always refer to
the Chezmoi source directory (`home/`) rather than the target locations in
`$HOME`. This repository is the source for dotfiles managed by Chezmoi.

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
