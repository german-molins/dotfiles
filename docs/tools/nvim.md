# Neovim

## LazyVim

[LazyVim](https://www.lazyvim.org/) is the used plugin manager.

Following is a list of plugins supported by LazyVim. For some of them I provide
explicit configuration that overrides the defaults:

- [Octo](https://github.com/pwntester/octo.nvim): Edit GH PRs, issues and
discussions.
- [`snacks.nvim`]
  - [Snacks Picker](https://github.com/folke/snacks.nvim/blob/main/docs/picker.md)

## Project-Local Configuration

Plugin `nvim-config-local` is used to load project-local configuration files.
It looks for Lua file `.nvim.lua`, asks for approval and loads them. By
convention in these dotfiles, they are to contain only imperative overrides of
configuration options set up by LazyVim, which uses function `setup` of the
declared plugin. For ready-to-use examples that can be copied into projects as
`.nvim.lua` files, see
`~/.config/nvim/lua/plugins/nvim-config-local/templates/*.lua`.

There is a custom mechanism to use these templates, available through commands

- `:DotfilesConfigInit`: Create or update `.nvim.lua` and append command that
loads (requires) all available modules under `.nvim/`, either files or
directories, be them from templates or not.
- `:DotfilesConfigCopy`: Interactively select a template and copy it to `.nvim/`.
