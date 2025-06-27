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

- Depends: nix:clean, brew:clean

- **Usage**: `clean`

Clean up system packages and caches

## `devbox:self-update`

- **Usage**: `devbox:self-update`

Update Devbox

## `devbox:update`

- **Usage**: `devbox:update`

Update Devbox global packages

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

## `self-update`

- Depends: devbox:self-update, brew:self-update

- **Usage**: `self-update`

## `update`

- Depends: chezmoi:update, mise:update, devbox:update, yazi:update, nvim:update, brew:update

- **Usage**: `update`

Update all tools and packages

## `yazi:install`

- **Usage**: `yazi:install`
- **Aliases**: `yazi:i`

Install Yazi packages

## `yazi:update`

- **Usage**: `yazi:update`
- **Aliases**: `yazi:up`

Update Yazi packages
