# Neovim

## Project-Local Configuration

Plugin `nvim-config-local` is used to load project-local configuration files.
It looks for Lua files `.nvim.lua`, asks for approval and loads them. By
convention in these dotfiles, they are to contain only imperative overrides of
configuration options set up by LazyVim, which uses function `setup` of the
declared plugin. For ready-to-use examples that can be copied into projects as
`.nvim.lua` files, see
`~/.config/nvim/lua/plugins/nvim-config-local/templates/*.lua`.
