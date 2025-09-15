# System Dependencies

## Dependencies managed by Mise

The following is a list of system-level dependencies required by various tools.
These dependencies are managed through different mise environments and
backends.

| Dependency | Environment | Backend | Tools |
|------------|-------------|---------|-------|
| cosign | global | aqua | mise |
| ffmpeg | opt | asdf | Yazi |
| resvg | opt | devbox | Neovim, Yazi |
| ImageMagick | devbox | devbox | Yazi |
| Pandoc | global | ubi | `pdftoepub`, Neovim plugins |
| `pdftotext` | devbox | devbox | `pdftoepub` |
| `md5sum` (uutils/coreutils) | global | aqua | Bash caching |

## Coreutils

Official uutils/coreutils GitHub releases provide a single binary `coreutils`
that implements various Unix core utilities as subcommands. To make individual
commands like `md5sum`, `sha256sum`, etc. available in the PATH, lightweight
shell script stubs are created in `~/.local/bin/`. This approach allows
seamless integration with tools expecting individual coreutils commands, and
integrates well with completion engines like Carapace.

Because of unavailability for mise of a "NOPREFIX" build of uutils/coreutils,
this custom approach is implemented for now.

## Dependencies managed by UPT

- Zsh
