# Neovim

## LazyVim

[LazyVim](https://www.lazyvim.org/) is the used plugin manager.

Following is a list of plugins supported by LazyVim. For some of them I provide
explicit configuration that overrides the defaults:

- [Octo](https://github.com/pwntester/octo.nvim): Edit GH PRs, issues and
discussions.
- [`snacks.nvim`]
  - [Snacks Picker](https://github.com/folke/snacks.nvim/blob/main/docs/picker.md)

## Plugins

### Zk

[zk-nvim](https://github.com/zk-org/zk-nvim) is used for note-taking with Zk.

#### Custom Commands

These custom commands are tightly coupled to the Zk configuration in
`home/private_dot_config/zk/config.toml` and the templates in
`home/private_dot_config/zk/templates/`:

- `:ZkNewLink`: Creates a new Zk note in the "archive" directory, inserts a
link to it at the current cursor position in normal mode, prompts for a title,
and opens the new buffer with the cursor positioned at the last line in insert
mode. This relies on the `group.archive.note` configuration (ID-based filename,
`note.md` template) and the `format.markdown` link format.
- `:ZkNewJournal`: Creates a new Zk note in the "journal" directory (using the
journal template with date-based title and filename), and opens the new buffer
with the cursor positioned at the last line in insert mode. This relies on the
`group.journal.note` configuration (date-time filename, `journal.md` template).

#### Keymaps

- `<leader>zn`: Run `:ZkNewLink` command.
- `<leader>zj`: Run `:ZkNewJournal` command.

## Colorschemes

- [Gruvbox](https://github.com/ellisonleao/gruvbox.nvim) (default)
- [NeoSolarized](https://github.com/Tsuzat/NeoSolarized.nvim)

### [Sidekick](https://github.com/folke/sidekick.nvim) (LazyVim extra)

- Copilot Tab completion and next cursor position prediction.
- Integration with many code assistant CLIs.

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
