# Zk

Zk is a plain text note-taking assistant that helps manage and create notes
with linking capabilities.

## Note Types

- **Zettel**: Atomic notes stored in the "archive" directory. These use
ID-based filenames (e.g., `a1b2c3d4.md`) for unique identification and are
designed to be linked together in a Zettelkasten system. Template: `note.md`.
- **Journal Entry**: Daily journal notes in the "journal" directory. These use
date-time based filenames (e.g., `2023-10-01_12-00-00.md`) for chronological
organization. Template: `journal.md`.
- **Meeting Note**: Meeting notes in the "meetings" directory. These use
date-time based filenames and prompt for a meeting title. Includes frontmatter
for participants and an agenda section. Template: `meeting.md`.

## Configuration

The Zk configuration is defined in `home/private_dot_config/zk/config.toml`.

Key configuration sections:

- `[note]`: Default settings for all notes (title, filename format, extension,
template, ID generation).
- `[group.archive.note]`: Specific settings for archive/zettel notes (ID
filename, `note.md` template).
- `[group.journal.note]`: Specific settings for journal notes (date-time
filename, `journal.md` template).
- `[group.meetings.note]`: Specific settings for meeting notes (date-time
filename, `meeting.md` template).
- `[format.markdown]`: Markdown-specific formatting (link format
`[[filename|title]]`, hashtag support).

## Templates

Templates are located in `home/private_dot_config/zk/templates/` and use
Handlebars syntax for dynamic content.

- `note.md`: Basic note template with frontmatter for title and tags, followed
by content placeholder.
- `journal.md`: Journal template with frontmatter including date-based title,
datetime, day of week, and tags, followed by content placeholder.
- `meeting.md`: Meeting template with frontmatter including titled meeting,
datetime, day of week, tags, and participants, followed by agenda and notes
sections.

## Integrations

### Neovim

See the [zk-nvim section in Neovim docs](./nvim.md#zk) for custom commands
and keymaps that integrate Zk with Neovim.

