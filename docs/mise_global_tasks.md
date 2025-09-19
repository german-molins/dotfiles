## `bash:clean`

- **Usage**: `bash:clean`

Clean bash startup caches

## `bash:profile`

- **Usage**: `bash:profile`

Process bash startup profiling logs and generate timing reports

## `brew:clean`

- **Usage**: `brew:clean`

Clean up Homebrew packages and caches

## `brew:self-update`

- **Usage**: `brew:self-update`

Update Homebrew

## `brew:update`

- **Usage**: `brew:update`

Update Homebrew global packages

## `chezmoi:update`

- **Usage**: `chezmoi:update`

Update Chezmoi

## `clean`

- Depends: mise:clean, nix:clean, brew:clean

- **Usage**: `clean`

Clean up system packages and caches

## `devbox:self-update`

- **Usage**: `devbox:self-update`

Update Devbox

## `devbox:update`

- **Usage**: `devbox:update`

Update Devbox global packages

## `mise:clean`

- **Usage**: `mise:clean`

Clean Mise cache

## `mise:lock`

- **Usage**: `mise:lock`

Lock mise dependencies

## `mise:update`

- **Usage**: `mise:update`
- **Aliases**: `mise:up`

Update Mise global packages

## `nerd-fonts:list`

- **Usage**: `nerd-fonts:list`

List installed Nerd Fonts

## `nix:clean`

- **Usage**: `nix:clean`

Clean up Nix packages and garbage collection

## `nvim:clean`

- **Usage**: `nvim:clean`

Clean Neovim plugins

## `nvim:install`

- **Usage**: `nvim:install`
- **Aliases**: `nvim:i`

Install Neovim plugins

## `nvim:reinstall`

- **Usage**: `nvim:reinstall`

Reinstall Neovim plugins

## `nvim:sync`

- **Usage**: `nvim:sync`

Sync Neovim plugins

## `nvim:update`

- **Usage**: `nvim:update`
- **Aliases**: `nvim:up`

Update Neovim plugins

## `python:init`

- **Usage**: `python:init`

Initialize a Python project with uv and pytest

## `python:scaffold`

- **Usage**: `python:scaffold`

Scaffold a Python project with uv and pytest

## `python:scaffold`

- **Usage**: `python:scaffold`

Scaffold a Python project with uv and pytest

## `python:tasks-add`

- **Usage**: `python:tasks-add`

Add default tasks for a Python project with uv and pytest

## `random-hex`

- **Usage**: `random-hex`
- **Aliases**: `rhex`

Generate a 32-bit random hex number

## `scaffold`

- **Usage**: `scaffold [--commit] <project>`

Scaffold a project

### Arguments

#### `<project>`

Project type

**Choices:**

- `python`

### Flags

#### `--commit`

Commit changes after scaffolding

## `self-update`

- Depends: devbox:self-update, brew:self-update

- **Usage**: `self-update`

## `update`

- Depends: chezmoi:update, mise:update, devbox:update, yazi:update, nvim:update, brew:update, upt:update

- **Usage**: `update`

Update all tools and packages

## `upt`

- **Usage**: `upt [cmd]…`

Install system packages with upt

### Arguments

#### `[cmd]…`

Command to run with upt

## `upt:update`

- **Usage**: `upt:update`

Update system packages

## `yazi:install`

- **Usage**: `yazi:install`
- **Aliases**: `yazi:i`

Install Yazi packages

## `yazi:update`

- **Usage**: `yazi:update`
- **Aliases**: `yazi:up`

Update Yazi packages

## `zippdf`

- **Usage**: `zippdf`

Compress PDF files in the current directory recursively
