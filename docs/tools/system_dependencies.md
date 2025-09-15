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

## Dependencies managed by UPT

- Zsh
